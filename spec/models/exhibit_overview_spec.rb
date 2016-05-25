require 'spec_helper'

describe ExhibitOverview do
  it 'belongs to an exhibit' do
    exhibit = Spotlight::Exhibit.new
    subject.exhibit = exhibit
    expect(subject.exhibit).to eql exhibit
  end
  it 'has an institution' do
    expect {
      subject.institution = 'Københavns Universitet'
    }.not_to raise_error
    expect(subject.institution).to eql 'Københavns Universitet'
  end
  it 'has a research area' do
    expect {
      subject.research_area = 'Politisk Økonomi'
    }.not_to raise_error
    expect(subject.research_area).to eql 'Politisk Økonomi'
  end
  it 'has contact details' do
    expect {
      subject.contact_details = 'Telefon +45 35 32 44 12'
    }.not_to raise_error
    expect(subject.contact_details).to eql 'Telefon +45 35 32 44 12'
  end
end
