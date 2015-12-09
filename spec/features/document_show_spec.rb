Capybara.javascript_driver = :webkit
feature 'Document show' do
  include_context 'common'

  background do
    pending 'Something going wrong here'
    visit root_path
    fill_in 'Search...', with: 'search terms'
    expect_any_instance_of(Net::HTTPResponse).to receive(:body).at_least(:once)
    .and_return(response_with_highlighting)
    click_button 'Search'
    click_link 'sample title'
    #  expect(Blacklight.solr).to receive(:get).and_return(default_show_response)
    # visit(solr_document_path({id: '2266145840'}))
  end

  scenario 'retrieving a citation' do
    click_link 'citeLink'
    expect(page).to have_content 'Modern Language Association'
    expect(page).to have_content 'APA'
    expect(page).to have_content 'Chicago Author Date'
  end

  context 'exporting', js: true  do
    pending 'Something going wrong here'
    scenario 'clicking on the export button makes options visible' do
      expect(page).not_to have_content 'Save to Mendeley'
      expect(page).not_to have_content 'Export to BibTeX'
      expect(page).not_to have_content 'Export to RIS'
      expect(page).not_to have_content 'Email citation'
      click_link 'Save and export'
      expect(page).to have_content 'Save to Mendeley'
      expect(page).to have_content 'Export to BibTeX'
      expect(page).to have_content 'Export to RIS'
      expect(page).to have_content 'Email citation'
    end

    scenario 'Email citation', js: true do
    pending 'Something going wrong here'
      click_link 'Save and export'
      click_link 'Email citation'
      fill_in 'To', with: 'tester@sample.com'
      select('APA', from: 'style')
      click_button 'Preview'
      expect(page).to have_content 'Benros, M. E.'
    end
  end
end
