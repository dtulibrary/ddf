feature 'Catalog search' do

  background do
    visit root_path
    fill_in 'Search...', with: 'diabetic medicine'
    click_button 'Search'
  end

  scenario 'Checking default facets' do
    expect(page).to have_content /limit your search/i
    expect(page).to have_content /type/i
    expect(page).to have_content /publication year/i
    expect(page).to have_content /submission year/i
    expect(page).to have_content /author/i
    expect(page).to have_content /research institution/i
    expect(page).to have_content /journal title/i
    expect(page).to have_content /language/i
    expect(page).to have_content /scientific level/i
    expect(page).to have_content /publication status/i
    expect(page).to have_content /review type/i
    expect(page).to have_content /main research area/i
  end

  scenario 'Checking default index fields' do
    within '#documents' do
      expect(page).to have_content /authors/i
      expect(page).to have_content /type/i
      expect(page).to have_content /published in/i
      expect(page).to have_content /doi/i
      expect(page).to have_content /main research area/i
      expect(page).to have_content /full text access/i
      expect(page).to have_content /data providers/i
    end
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