# Connects to OA Indicator API and transforms response
class OpenAccessIndicator
  # TODO: refactor url into config file
  def self.fetch(resource, year)
    url = 'http://oa-indicator.cvt.dk/oa-indicator/ws/%{resource}.json/%{year}/devel' %
        { year: year, resource: resource }
    response = Net::HTTP.get_response(URI(url)) rescue nil
    Response.relative_values(response.body, resource) if response.is_a? Net::HTTPSuccess
  end

  class Response
    def self.body(response)
      JSON.parse(response)['oa_indicator']['response']['body']
    end

    # response format is inconsistent for national level Indicator
    # therefore we need to transform output into generic format
    def self.relative_values(response, resource)
      body = self.body(response)
      if resource == 'national'
        { 'national' => body['relative'] }
      else
        stats = {}
        body.each { |k,v| stats[k] = v['relative'] }
        stats
      end
    end
  end
end
