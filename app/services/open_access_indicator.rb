# Connects to OA Indicator API and transforms response
class OpenAccessIndicator

  RESOURCES = ['national'.freeze, 'universities'.freeze, 'research_area'.freeze]
  CLASSIFICATIONS = ['realized'.freeze, 'unused'.freeze, 'unclear'.freeze]
  # Get vals from config - ensure that they are ordered by latest first
  YEARS = Rails.configuration.x.open_access.years.sort.reverse

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
    url = self.url(year, resource)
    Rails.logger.info "OpenAccessIndicator: Fetching #{url}"
    response = Net::HTTP.get_response(URI(url)) rescue nil
    if Response.ok? response
      Response.values(response.body, resource, view)
    else
      Rails.logger.error "OpenAccessIndicator: Error #{Response.error_message(response.body)}"
      nil
    end
  end

  def self.timeline(resource, key)
    timeline = { key => {} }
    YEARS.each do |year|
      response = Net::HTTP.get_response(URI(self.url(year, resource))) rescue nil
      if Response.ok? response
        timeline[key][year.to_s] = Response.timeline_values(response.body, resource, key)
      end
    end
    timeline
  end

  def self.url(year, resource)
    Rails.configuration.x.open_access.url % { year: year, resource: resource, format: 'json' }
  end

  class Response
    def self.ok?(response_obj)
      response_obj.is_a?(Net::HTTPSuccess) && self.error_message(response_obj.body).nil?
    end

    def self.error_message(response_body)
      JSON.parse(response_body)['oa_indicator']['response']['error'] rescue nil
    end

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

    def self.timeline_values(response_body, resource, key)
      h = self.values(response_body, resource, 'relative')[key]
      { 'relative' => h['relative']['realized'], 'absolute' => h['absolute']['realized'] }
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
