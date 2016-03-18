class DDFPresenter < Dtu::DocumentPresenter
  include ActionView::Context

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
    dated_affiliations = {}
    affiliations.each do |aff|
      aff_end = parse_date(aff['endDate'])
      dated_affiliations[aff_end] = ''
      affiliation = ''
      aff['organisation']['names'].each do |n|
        names = []
        names << n['level1'] << n['level2'] << n['level3'] << n['lang']
        affiliation << names.compact.join(' - ')
      end
      affiliation << ' '  << affiliation_dates(aff['startDate'], aff['endDate']) unless status == 'current'
      dated_affiliations[aff_end] = affiliation
    end
    dated_affiliations.sort_by {|date, _| date }.reverse.collect(&:last).join("<br/>").html_safe
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
