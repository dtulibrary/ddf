# Connects to OA Indicator API and transforms response
class OpenAccessIndicator

  RESOURCES = ['national'.freeze, 'universities'.freeze, 'research_area'.freeze]
  CLASSIFICATIONS = ['realized'.freeze, 'unused'.freeze, 'unclear'.freeze]

  # Query API and convert response into a hash of values
  #
  # ==== Attributes
  #
  # * +resource+ the requested grouping: national | universities | research_area
  # * +year+ the requested year
  # * +view+ relative | relative_clear
  #
  # ==== Examples
  #
  # OpenAccessIndicator.fetch('national', '2015', 'relative_clear')
  def self.fetch(resource, year, view = 'relative')
    url = Rails.configuration.x.open_access.url % { year: year, resource: resource, format: 'json' }
    Rails.logger.info "OpenAccessIndicator: Fetching #{url}"
    response = Net::HTTP.get_response(URI(url)) rescue nil
    Response.values(response.body, resource, view) if response.is_a? Net::HTTPSuccess
  end

  class Response
    def self.body(response)
      JSON.parse(response)['oa_indicator']['response']['body']
    end

    # response format is inconsistent for national level Indicator
    # therefore we need to transform output into generic format
    def self.values(response, resource, view)
      body = self.body(response)
      if resource == 'national'
        { 'national' => { view => body[view], 'absolute' => self.absolute_values(body) } }
      else
        stats = {}
        body.each do |k,v|
          stats[k] = {} if stats[k].nil?
          stats[k][view] = v[view]
          stats[k]['absolute'] = self.absolute_values(body, k)
        end
        stats
      end
    end

    def self.absolute_values(body, key = nil)
      absolute = {}
      OpenAccessIndicator::CLASSIFICATIONS.each do |cls|
        if key.nil?
          absolute[cls] = body[cls]
        else
          absolute[cls] = body[key][cls]
        end
      end
      absolute
    end
  end
end
