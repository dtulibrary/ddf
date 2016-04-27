class PersonPresenter < Dtu::DocumentPresenter
  include ActionView::Context

  def person_name
    document['name_ts'].first || document.id
  end

  def fetch_publications
    solr = SolrService.new
    publications = solr.author_docs(document.cris_id)
    publications[:docs] = publications[:docs].collect { |doc| SolrDocument.new(doc) }
    publications
  end

  def publications
    @publications ||= fetch_publications
  end

  def affiliations
    aff_data = document['person_affiliations_ssf'].try(:first)
    output = {}
    output['current'] = render_affilations(aff_data, 'current')
    output['previous'] = render_affilations(aff_data, 'previous')
    output.select { |_,val| val.present? }.transform_values {|list| "<ol>#{list}</list>".html_safe }
  end

  def render_affilations(data, status)
    return unless data.present?
    affiliations = JSON.parse(data)
    affiliations.select! { |h| h['type'] == status }
    affiliation_data = []
    affiliations.each do |aff|
      aff_end = parse_date(aff['endDate'])
      aff_description = ''
      aff['organisation']['names'].each do |n|
        names = []
        names << n['level1'] << n['level2'] << n['level3'] << n['level4']
        aff_description << names.compact.join(' - ')
      end
      if status == 'previous' # no dates on current affiliations
        aff_description << ' '  << affiliation_dates(aff['startDate'], aff['endDate'])
      end
      affiliation_data << [aff_end, aff_description]
    end
    # sort affiliations with most recently finished first
    aff_sorted = affiliation_data.sort_by {|date, _| date }.reverse
    # only take text portion
    list_elems = aff_sorted.collect(&:last)
    # wrap elements in li tags
    list_elems.collect{ |elem| "<li>#{elem}</li>"}.join
  end

  def affiliation_dates(start_d, end_d)
    "<span class='affiliation-dates'>(#{format_date(start_d)} - #{format_date(end_d)})</span>"
  end

  def format_date(d)
    date = parse_date(d)
    content_tag :time, datetime: date.strftime do
      date.strftime('%d/%m-%Y')
    end
  end

  def image
    if document.image.present?
      "<object data='#{document.image}'></object>"
    else
      ''
    end
  end

  def parse_date(d)
    d.nil? ? Date.today : Date.parse(d)
  end
end
