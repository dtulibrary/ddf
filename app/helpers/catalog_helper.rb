module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # Get the last news item from our locale files
  def latest_update
    last = t('ddf.news.updates').keys.last
    t('ddf.news.updates')[last].html_safe
  rescue
    nil
  end
  def render_fulltext_access? document
    !(collect_fulltexts(document) + collect_dois(document)).empty?
  end

  def render_data_providers? document
    !collect_backlinks(document).empty?
  end

  def render_format_field_facet value
    t "mxd_type_labels.publication_type_labels.#{value}"
  end

  def render_source_field_facet value
    facet_source_label(value)
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

  # Only show the published date as an independent field
  # if there is no journal title, conference title or publisher -
  # otherwise it will be appended to these
  def show_publication_year? _field_config, doc
    doc['journal_title_ts'].blank? && doc['conf_title_ts'].blank? && doc['publisher_ts'].blank?
  end

  # "backlink_ss": [
  #   "http://aarch.dk/publications/6b563f21-3451-4e71-8ee3-14a21ee341d1"

  def render_journal_info args, format = :index
    document = args[:document]
    [render_first_highlight_field(args),
     render_journal_subtitle_info(document, format),
     render_pub_date_info(document, format),
     render_journal_vol_info(document, format),
     render_journal_issue_info(document, format),
     render_journal_page_info(document, format)].join('').html_safe
   end

   def render_conf_title(args)
    doc = args[:document]
    if doc['conf_title_ts'].present?
      title = doc['conf_title_ts'].first
      # do not append pub date if there is a 4 digit number present in the title
      if title =~ / \d{4}/
        title
      else
        title + render_pub_date_info(doc, :show)
      end
    end
  end

  def render_publisher(args)
    doc = args[:document]
    if doc['publisher_ts'].present?
      info = render_first_highlight_field(args)
      # if there is no journal title conference title, append published date here
      unless doc['journal_title_ts'].present? || doc['conf_title_ts'].present?
        info += render_pub_date_info(doc, :show)
      end
      info
    end
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

  def render_journal_title_info(document, format = nil)
    if document['journal_title_ts']
      "#{document['journal_title_ts'].first}"
    else
      ''
    end
  end

  def render_journal_subtitle_info document, format
    if document['journal_subtitle_ts']
      ": #{document['journal_subtitle_ts'].first}"
    else
      ''
    end
  end

  def render_pub_date_info document, format
    if document['pub_date_tis']
      ", #{document['pub_date_tis'].first}"
    else
      ''
    end
  end

  def render_journal_issue_info document, format
    if document['journal_issue_ssf']
      ", Issue #{document['journal_issue_ssf'].first}"
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

  def facet_source_label source
    t "mxd_type_labels.facet_source_labels.#{source}"
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

  # values MUST match image file names
  PROVIDER_CODES = {
    rdb_sbi: 'capital-region',
    rdb_ka:  'ministry-of-culture',
    rdb_cbs: 'cph-business-school',
    rdb_ruc: 'roskilde-university',
    rdb_ku:  'copenhagen-university',
    rdb_itu: 'it-university-of-cph',
    rdb_fak: 'danish-defence-college',
    rdb_sdu: 'university-southern-denmark',
    orbit:   'technical-university-of-dk',
    rdb_vbn: 'aalborg-university',
    rdb_au:  'aarhus-university',
    rdb_ark: 'architecture-design-conservation'
  }

  def render_provider_logos
    return unless providers_params.present?
    image_names = providers_params.map { |code| PROVIDER_CODES[code.to_sym] }
    images = image_names.map do |name|
      content_tag(:li, class: name) do
        link_to(render_logo_from(name), data_provider_path(name)) +
        content_tag(:i, "", class: "glyphicon glyphicon-info-sign")
      end
    end
    images.join.html_safe
  end

  # Not using semantic names for the partials, OK?
  def render_provider_cards
    return unless providers_params.present?
    providers_params.map { |prov| render "catalog/providers/#{prov}" }.join.html_safe
  end

  def providers_params
    params['f']['source_ss'] rescue nil
  end

  def render_logo_from(image_name)
    image_tag(small_logo_path(image_name))
  end

  def data_provider_path(image_name)
    "about/research-institutions/##{image_name}"
  end

  def small_logo_path(image_name)
    path_with_locale    = "data-providers/small/#{image_name}.#{I18n.locale}.png"
    path_without_locale = "data-providers/small/#{image_name}.png"
    static_asset = Rails.application.assets.find_asset(path_with_locale) || Rails.application.assets.find_asset(path_without_locale)
    static_asset.logical_path
    # TODO: Handle exception(s)
  end

  SELECTED_SORT_FIELDS = ['year', 'title']

  def active_sort_fields_selected
    active_sort_fields.select { |k, v| SELECTED_SORT_FIELDS.include? v.label }
  end

  # This is a modified version of Blacklight::CatalogHelperBehavior#current_sort_field
  def current_sort_field_selected
    sort_field_from_response ||  # as in original
    sort_field_from_params ||    # sort param specified
    sort_field_from_list ||      # sort param not specified
    default_sort_field           # falls back on 'relevance'
  end

  def sort_field_from_response
    if @response && @response.sort.present?
      blacklight_config.sort_fields.values.find { |f| f.sort.eql? @response.sort }
    end
  end

  def sort_field_from_params
    blacklight_config.sort_fields[params[:sort]]
  end

  def sort_field_from_list
    active_sort_fields_selected.shift[1]
  end

  # Highwire expects names in format Firstname Lastname
  def highwire_author_format(name)
    if name.include? ','
      name.split(',').reverse.join(' ').strip
    else
      name
    end
  end

  def format_issn(val)
    if val.include? '-'
      val
    elsif val.class == String && val.size == 8
      val.insert(4, '-')
    else
      nil
    end
  end

  def highwire_issn_tags(doc)
    issns = doc['issn_ss']
    return unless issns.present?
    vals = issns.collect do |issn|
      val = format_issn(issn)
      citation_tag('issn', val) if val.present?
    end
    vals.join("\n")
  end

  def highwire_author_tags(doc)
    authors = doc['author_ts']
    return unless authors.present?
    vals = authors.collect do |val|
      name = highwire_author_format(val)
      citation_tag('author', name) if name.present?
    end
    vals.join("\n")
  end

  def highwire_journal_title_tag(doc)
    title = render_journal_title_info(doc)
    if doc['subformat_s'] == 'bookchapter'
      citation_tag('inbook_title', title) if title.present?
    else
      citation_tag('journal_title', title) if title.present?
    end
  end
  # We supply Procs where additional logic is necessary to
  # transform the value
  # Otherwise the document key is used
  META_FIELDS = {
    title: 'title_ts',
    author: :highwire_author_tags,
    publication_date: 'pub_date_tis',
    publisher: 'publisher_ts',
    journal_title: :highwire_journal_title_tag,
    language: 'language_ss',
    conference_title: 'conf_title_ts',
    isbn: 'isbn_ss',
    doi: 'doi_ss',
    issn: :highwire_issn_tags
  }

  JOINED_META_FIELDS = { citation_keywords: 'keywords_ts' }

  def citation_tags_for(document)
    return if document.nil?
    taglist = []
    taglist << "\n"
    META_FIELDS.each do |k, v|
      if v.class == Symbol && self.respond_to?(v)
        taglist << send(v, document)
      elsif document[v]
        if document[v].length.eql?(1)
          taglist << atomic_citation_tag_for(k, document[v])
        else
          taglist << split_citation_tags_for(k, document[v])
        end
      end
    end
    JOINED_META_FIELDS.each do |k, v|
      if document[v]
        taglist << joined_citation_tags_for(k, document[v])
      end
    end
    taglist.join("\n").html_safe
  end

  def atomic_citation_tag_for(field_name, field_value)
    citation_tag(field_name, field_value.join())
  end

  def split_citation_tags_for(field_name, field_value)
    field_value.map { |str| citation_tag(field_name, str) }.join("\n").html_safe
  end

  def joined_citation_tags_for(field_name, field_value)
    citation_tag(field_name, field_value.join("; "))
  end

  def citation_tag(tag, content)
    "<meta name=\"citation_#{tag}\" content=\"#{content}\" />".html_safe
  end
end
