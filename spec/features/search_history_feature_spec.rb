feature 'search history' do 
  let(:search_term) { 'fish' }

  background do
    visit root_path
    fill_in 'Search...', with: search_term
    click_button 'Search'
  end

  scenario 'search history should be populated by past searches' do
  	visit search_history_path
  	expect(page).to have_content search_term
  end

  scenario 'clicking on a search history link should return us to a search' do
  	visit search_history_path
  	click_link(search_term)
  	expect(page.current_url).to include catalog_index_path
  end	
 end	