# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.application.config.sitemap[:host]

SitemapGenerator::Sitemap.create do
  break unless Rails.application.config.sitemap[:generate]

  # Add static pages
  [:en, :da].each do |locale|
    ['', 'search-and-get', 'data', 'faq'].each do |page|
      add "/#{locale}/about/#{page}"
    end
  end

  # Add single record pages
  Tempfile.open('dedup_file', '/tmp') do |file|
    uri = URI(Rails.application.config.sitemap[:dedup_source_url])

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri.request_uri

      http.request request do |response|
        response.read_body do |chunk|
          file.write chunk
        end
      end
    end
    
    file.close

    IO.foreach(file) do |line|
      add "/catalog/#{line.chomp}"
    end
  end
end
