Capybara.javascript_driver = :selenium
feature 'Document show' do
  include_context 'common'

  background do
    visit root_path
    fill_in 'Search...', with: 'constant'
    click_button 'Search'
    first('h5.doctitle').find('a').click
  end

  scenario 'retrieving a citation' do
    click_link 'citeLink'
    expect(page).to have_content 'Modern Language Association'
    expect(page).to have_content 'APA'
    expect(page).to have_content 'Chicago Author Date'
  end

  context 'exporting', js: true  do
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
      fill_in 'To', with: 'tester@sample.com'
      select('APA', from: 'style')
      click_button 'Preview'
      expect(page).to have_content 'Preview citations'
    end
  end
end
