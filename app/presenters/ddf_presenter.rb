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
    output = []
    affiliations.each do |aff|
      affiliation = ''
      aff['organisation']['names'].each do |n|
        names = []
        names << n['level1'] << n['level2'] << n['level3'] << n['lang']
        affiliation << names.compact.join(' - ')
      end
      affiliation << ' '  << affiliation_dates(aff['startDate'], aff['endDate']) unless status == 'current'
      output << affiliation
    end
    output.join("<br/>").html_safe
  end

  def affiliation_dates(start_d, end_d)
    "(#{format_date(start_d)} - #{format_date(end_d)})"
  end

  def format_date(d)
    date = Date.parse(d)
    content_tag :time, datetime: date.strftime do
      date.strftime('%d/%m-%Y')
    end
  end
end
