class PersonPresenter < Dtu::DocumentPresenter
  include ActionView::Context

  def person_name
    document['name_ts'].first || document.id
  end

  def cris_id
    document['cris_id_ss'].try(:first) || parse_cris_id
  end

  def parse_cris_id
    if document.backlink.present?
      document.backlink.slice(/\(.*\)/).sub('(', '').sub(')','')
    end
  end

  def publications
    solr = SolrService.new
    publications = solr.author_docs(cris_id)
    publications[:docs] = publications[:docs].collect { |doc| SolrDocument.new(doc) }
    publications
  end

  def affiliations
    aff_data = document['person_affiliations_ssf'].try(:first)
    output = {}
    ['current', 'previous'].each do |type|
      output[type] = render_affilations(aff_data, type)
    end
    output.select { |_,val| val.present? }
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
    aff_sorted.collect(&:last).join("<br/>").html_safe
  end

  def affiliation_dates(start_d, end_d)
    "(#{format_date(start_d)} - #{format_date(end_d)})"
  end

  def format_date(d)
    date = parse_date(d)
    content_tag :time, datetime: date.strftime do
      date.strftime('%d/%m-%Y')
    end
  end

  def parse_date(d)
    d.nil? ? Date.today : Date.parse(d)
  end
end
