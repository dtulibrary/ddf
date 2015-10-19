module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def render_format_field_facet value
    t "mxd_type_labels.publication_type_labels.#{value}"
  end

  def render_source_field_facet value
    source_label(value)
  end

  def render_language_field_facet value
    t "mxd_type_labels.language_labels.#{value}"
  end

  def render_publication_status_facet(value)
    t "mxd_type_labels.publishing_status_labels.#{value}"
  end

  def render_review_status_facet(value)
    t "mxd_type_labels.review_status_labels.#{value}"
  end

  # In the perfect world...
  # def render_journal_title_facet(value)
  # end

  def render_research_area_facet value
    case value
    when 'Humanities'
      str = 'hum'
    when 'Medical science'
      str = 'med'
    when 'Science/technology'
      str = 'sci'
    when 'Social science'
      str = 'soc'
    end
    t "mxd_type_labels.research_area_labels.#{str}"
  end

  def render_scientific_level_facet(value)
     t "mxd_type_labels.scientific_level_labels.#{value}"
  end

  def render_source_field args
    args[:document]['source_ss'].collect {|s| source_label(s)}.join ' ; '
  end

  def render_format_field_index args
    t "mxd_type_labels.publication_type_labels.#{args[:document]['format_orig_s']}"
  end

  def render_research_area_field args
    args[:document]['research_area_ss'].collect {|s| t "research_area_labels.#{s}"}.join ' ; '
  end

  def render_publishing_status(opts)
    field = opts[:document][opts[:field]]
    if field.is_a? Array
      field.map { |s| t "mxd_type_labels.publishing_status_labels.#{s}" }.join ' ; '
    else
      t "mxd_type_labels.publishing_status_labels.#{field}"
    end
  end

  def render_language(opts)
    field = opts[:document][opts[:field]]
    if field.is_a? Array
      field.map { |s| t "mxd_type_labels.language_labels.#{s}" }.join ' ; '
    else
      t "mxd_type_labels.language_labels.#{field}"
    end
  end

  def render_type(opts)
    field = opts[:document][opts[:field]]
    if field.is_a? Array
      field.map { |s| t "mxd_type_labels.publication_type_labels.#{s}" }.join ' ; '
    else
      t "mxd_type_labels.publication_type_labels.#{field}"
    end
  end

  # Try toggling the comments on & off, watch what happens to translations
  # of labels above. Also, the method body works in spite of being a duplication
  # render_type() above.
  def render_review_status(opts)
    field = opts[:document][opts[:field]]
    # binding.pry
    if field.is_a? Array
      field.map { |s| t "mxd_type_labels.review_status_labels.#{s}" }.join ' ; '
    else
      t "mxd_type_labels.review_status_labels.#{field}"
    end
  end

  def render_scientific_level(opts)
    field = opts[:document][opts[:field]]
    # binding.pry
    if field.is_a? Array
      field.map { |s| t "mxd_type_labels.scientific_level_labels.#{s}" }.join ' ; '
    else
      t "mxd_type_labels.scientific_level_labels.#{field}"
    end
  end

  def debug_shite(opts)
    field = opts[:document][opts[:field]]
    # binding.pry
  end


  # def render_series(opts)
  #   field = opts[:document][opts[:field]]
  #   if field.is_a? Array
  #     field.map { |s| t "publishing_status_labels.#{s}" }.join ' ; '
  #   else
  #     t "publishing_status_labels.#{field}"
  #   end
  # end

  # # ALTERNATIVE 1:
  # def render_source_field_value(opts)
  #   # ONLY USE THIS PATH IN THIS METHOD:
  #   "source_labels.#{field}"
  # end

  # # ALTERNATIVE 2:
  # def render_any_field_value(opts, path_to_translation) # PASS THE PATH IN ARGS:
  #   "source_labels.#{field}"
  # end


  def get_backlink_origin link
    case link
    when /^https?:\/\/orbit\.dtu\.dk/
      'orbit'
    when /^https?:\/\/pure\.au\.dk/
      'rdb_au'
    when /^https?:\/\/forskning\.ku\.dk/
      'rdb_ku'
    when /^https?:\/\/pure\.itu\.dk/
      'rdb_itu'
    when /^https?:\/\/research\.cbs\.dk/
      'rdb_cbs'
    when /^https?:\/\/vbn\.aau\.dk/
      'rdb_vbn'
    when /^https?:\/\/rucforsk\.ruc\.dk/
      'rdb_ruc'
    when /^https?:\/\/findresearcher\.sdu\.dk/
      'rdb_sdu'
    when /^https?:\/\/forskning\.regionh\.dk/
      'rdb_sbi'
    when /^https?:\/\/pure-\d{2}\.kb\.dk/
      'rdb_ka'
    when /^https?:\/\/research\.kadk\.dk/
      'rdb_ark'
    when /^https?:\/\/pure\.fak\.dk/
      'rdb_fak'
    when /^https?:\/\/aarch\.dk/
      # This is a pseudo source name that only exists here
      # to handle two sources packed into one Pure backend.
      'rdb_aarch'
    else
      raise "Couldn't find data provider for the url: #{link}"
    end
  end

  # "backlink_ss": [
  #   "http://aarch.dk/publications/6b563f21-3451-4e71-8ee3-14a21ee341d1"

  def render_journal_info args, format = :index
    document = args[:document]
    field = args[:field]
    [render_journal_title_info(document, format),
     render_journal_pub_date_info(document, format),
     render_journal_vol_info(document, format),
     render_journal_issue_info(document, format),
     render_journal_page_info(document, format)].join('').html_safe
   end


   def render_journal_page_info document, format
    if document['journal_page_ssf']
      ", p. #{document['journal_page_ssf'].first}"
    else
      ''
    end
  end

  def render_journal_vol_info document, format
    if document['journal_vol_ssf']
      ", Vol #{document['journal_vol_ssf'].first}"
    else
      ''
    end
  end

  def render_journal_title_info document, format
    if document['journal_title_ts']
      "#{document['journal_title_ts'].first}"
    else
      ''
    end
  end

  def render_journal_pub_date_info document, format
    if document['pub_date_tis']
      ", #{document['pub_date_tis'].first}"
    else
      ''
    end
  end

  def render_journal_issue_info document, format
    if document['journal_issue_ssf']
      ", No. #{document['journal_issue_ssf'].first}"
    else
      ''
    end
  end

  def render_author_list authors
    list = (document['author_ts']).first
    return list.join(authors || content_tag(:span, '; ')).html_safe
  end

  def snip_abstract args
    render_abstract_snippet args[:document]
  end

  def render_abstract_snippet document
    snippet = (document['abstract_ts'] || ['No abstract']).first
    return snippet.size > 500 ? snippet.slice(0, 500) + '...' : snippet
  end

  def snip_abstract args
    render_abstract_snippet args[:document]
  end

  def render_abstract_snippet document
    snippet = (document['abstract_ts'] || ['No abstract']).first
    return snippet.size > 500 ? snippet.slice(0, 500) + '...' : snippet
  end

  def source_label source
    t "mxd_type_labels.source_labels.#{source}"
  end
 ##
  # Look up the current per page value, or the default if none if set
  #
  # @return [Integer]
  def current_per_page
    (@response.rows if @response and @response.rows > 0) || params.fetch(:per_page, default_per_page).to_i
  end

  #TODO: Clean up _index_default.html.erb with this
  def render_institutions_list(document)
    list = (document['backlink_ss'] || []).map do |link|
      content_tag :li do
        # render partial(link) here
      end
    end
    list.join('; ').html_safe
  end

  def collect_fulltexts document
    (document['fulltext_list_ssf'] || []).map {|json| JSON.parse json}
  end

  def collect_dois document
    (document['doi_ss'] || [])
  end

  def collect_doi_links document
    collect_dois(document).map {|doi| "http://dx.doi.org/#{doi}"}
  end

  def collect_backlinks document
    (document['backlink_ss'] || [])
  end
end
