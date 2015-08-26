module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def render_format_field_facet value
    t "mxd_type_labels.#{value}"
  end

  def render_source_field_facet value
    t "source_labels.#{value}"
  end

  def render_research_area_facet value
    t "research_area_labels.#{value}"
  end

  def render_source_field args
    args[:document]['source_ss'].collect {|s| t "source_labels.#{s}"}.join ' ; '
  end

  def render_format_field_index args
    t "mxd_type_labels.#{args[:document]['format_orig_s']}"
  end

  def render_research_area_field args
    args[:document]['research_area_ss'].collect {|s| t "research_area_labels.#{s}"}.join ' ; '
  end

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
    else
      raise "Couldn't find data provider for the url: #{link}"
    end
  end

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
end
