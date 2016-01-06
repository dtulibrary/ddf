feature 'DDF Index Page' do

  background do
    visit root_path
  end

  scenario 'Inspecting default facets' do
    expect(page).to have_content /publications by type/i
    expect(page).to have_content /publications by institution/i
  end

  scenario 'Clicking on facet leads to search' do
    click_link 'Journal article'
    expect(current_path).to include catalog_index_path
  end

  scenario 'Making a search from the search box' do
    fill_in 'Search...', with: 'diabetic medicine'
    click_button 'Search'
    expect(current_path).to include catalog_index_path
  end
end