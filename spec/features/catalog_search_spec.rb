feature 'Catalog search' do
  describe 'publications search' do
    let(:search_term) { 'fish' }
    background do
      visit root_path
      fill_in 'Search...', with: search_term
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

    describe 'orcid search' do
      let(:search_term) { '0000-0001-6296-3310' }
      it 'should not retrieve researchers' do
        expect(page).to have_content 'Your search did not find any records'
      end
    end
  end
end
