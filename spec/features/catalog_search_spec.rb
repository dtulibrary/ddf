feature 'Catalog search' do

  background do
    visit root_path
    fill_in 'Search...', with: 'fish'
    click_button 'Search'
  end

  scenario 'Checking per page toggle' do
    within '#per_page-dropdown' do
      expect(page).to have_content '10'
      expect(page).to have_content '20'
      expect(page).to have_content '50'
    end
  end

  scenario 'Checking sort types' do
    within '#sort-dropdown' do
      expect(page).to have_content 'relevance'
      expect(page).to have_content 'year'
      expect(page).to have_content 'title'
    end
  end
end
