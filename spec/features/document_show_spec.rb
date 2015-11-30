Capybara.javascript_driver = :webkit
feature 'Document show' do

  given(:params) {{ id: '269784833' }}
  background do
    visit(solr_document_path(params))
  end

  scenario 'retrieving a citation' do
    click_link 'citeLink'
    expect(page).to have_content 'Modern Language Association'
    expect(page).to have_content 'Apa'
    expect(page).to have_content 'Chicago Author Date'
  end

  context 'exporting a document', js: true  do
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
      click_link 'Save and export'
      click_link 'Email citation'
      fill_in 'Email', with: 'tester@sample.com'
      select('apa', from: 'style')
      click_button 'Preview'
      expect(page).to have_content 'Baron, C. P.'
    end
  end
end