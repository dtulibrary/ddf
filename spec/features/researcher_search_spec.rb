feature 'Researcher search' do
  let(:search_term) { 'Jens' }
  background do
    visit root_path
    fill_in 'Search...', with: search_term
    select('Researchers', from: 'search_field')
    click_button 'Search'
  end

  scenario 'name search' do
    expect(page).to have_content search_term
  end

  scenario 'sorting' do
    within '#sort-dropdown' do
      expect(page).to have_content 'relevance'
      expect(page).to have_content 'surname'
      expect(page).not_to have_content 'year'
      expect(page).not_to have_content 'title'
      click_link 'name'
    end
    expect(page).to have_content search_term
  end

  scenario 'show page' do
    click_link(search_term, match: :first)
    expect(page).to have_content search_term
  end

  feature 'orcid search' do
    let(:search_term) { '0000-0001-6296-3310' }
    scenario 'results' do
      expect(page.find_all('em', text: search_term).first).not_to be_nil
    end
  end
end
