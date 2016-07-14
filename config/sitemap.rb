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
  cursorMark = '*'
  loop do
    response = Blacklight.solr.get('/solr/metastore/ddf_publ', :params => {
      'q'          => '*:*',
      'fl'         => 'cluster_id_ss',
      'fq'         => 'NOT format:person',
      'cursorMark' => cursorMark,
      'rows'       => ENV['BATCH_SIZE'] || 1000,
      'sort'       => 'id asc'
    })

    response['response']['docs'].each do |doc|
      add "/catalog/#{doc['cluster_id_ss'].first}"
    end

    break if response['nextCursorMark'] == cursorMark

    cursorMark = response['nextCursorMark']
  end
end
