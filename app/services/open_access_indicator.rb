# Connects to OA Indicator API and transforms response
class OpenAccessIndicator

  RESOURCES = {
    'national' => ['national'.freeze],
    'research_area' => ['hum'.freeze, 'soc'.freeze, 'sci'.freeze, 'med'.freeze ],
    'universities' => [
      'sdu'.freeze, 'au'.freeze, 'ruc'.freeze, 'aau'.freeze,
      'itu'.freeze, 'dtu'.freeze, 'ku'.freeze, 'cbs'.freeze
    ]
  }

  CLASSIFICATIONS = ['realized'.freeze, 'unused'.freeze, 'unclear'.freeze]
  # Get vals from config - ensure that they are ordered by latest first
  YEARS = Rails.configuration.x.open_access.years.sort.reverse
  REPORTS = [ 'summary'.freeze, 'publications'.freeze, 'records'.freeze ]
  LANGUAGES = { da: 'dan', en: 'eng' }

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
    response = self.get_resource(year, resource)
    if response.nil?
      nil
    else
      Response.values(response, resource, view)
    end
  end

  def self.timeline(resource, key)
    timeline = { key => {} }
    YEARS.each do |year|
      response = self.get_resource(year, resource)
      if response.present?
        timeline[key][year.to_s] = Response.timeline_values(response, resource, key)
      end
    end
    timeline
  end

  def self.resource_url(year, resource)
    URI(Rails.configuration.x.open_access.url % { year: year, resource: resource, format: 'json' })
  end

  def self.status_url
    URI(Rails.configuration.x.open_access.status_api)
  end

  def self.report_urls(year, lang)
    urls = {}
    lang_code = LANGUAGES[lang]
    REPORTS.each do |report|
      urls[report] = self.proxy_url(year, lang_code, report)
    end
    urls
  end

  def self.proxy_url(year, lang, report)
    '/open_access/reports?report=%{report}&year=%{year}&lang=%{lang}&profile=%{profile}' % {
      year: year, lang: lang, report: report, profile: self.profile
    }
  end

  def self.report_url(year, lang, report)
    filename = self.report_name(year, lang, report)
    Rails.configuration.x.open_access.report_url % {
      year: year, lang: lang, report: report, profile: self.profile,
      filename: filename
    }
  end

  def self.report_name(year, lang, report)
    Rails.configuration.x.open_access.report_name % {
      year: year, lang: lang, report: report
    }
  end

  def self.profile
    Rails.configuration.x.open_access.api_profile
  end

  # Check to see if we have a cached copy before calling Open Access API
  def self.get_resource(year, resource)
    response = self.get(self.resource_url(year, resource))
  end

  # Generic handling of HTTP requests in this context
  def self.get(url)
    Rails.logger.info "OpenAccessIndicator: Getting #{url.to_s}"
    response = Net::HTTP.get_response(url) rescue nil
    if response.nil? || !(response.is_a? Net::HTTPSuccess)
      nil
    elsif !Response.ok?(response.body)
      Rails.logger.error "OpenAccessIndicator: Error #{Response.error_message(response)}"
      nil
    else
      response.body
    end
  end

  class LocalCache
    def self.update_needed?
      status = OpenAccessIndicator.get(OpenAccessIndicator.status_url)
      return if status.nil?
      values = StatusResponse.values(status, OpenAccessIndicator.profile)
      values.each do |year, tstamp|
        path = self.path(year, tstamp)
        return true unless File.exist? path
      end
      false
    end

    def self.read_latest(year)
      latest = Dir.entries(self.path(year))
        .reject { |x| x.include? '.' }
        .sort
        .last
      File.open(self.path(year, latest)).read
    end

    def self.path(*args)
      Rails.root.join('tmp', 'open_access', *args)
    end
  end
  # For handling the status API
  # We use XML parsing here because the JSON API is not well structured
  class StatusResponse

    def self.values(response_body, profile)
      values = {}
      nok = Nokogiri::XML(response_body)
      years = nok.xpath('//year').each do |node|
        values[node['val']] = node.xpath("types/#{profile}/runs/run/end").text
      end
      values
    end
  end

  # Handles parsing of API responses
  class Response
    def self.ok?(response)
      self.error_message(response).nil?
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
        stats.sort_by { |_k, v| v[view]['realized']}.reverse.to_h
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
