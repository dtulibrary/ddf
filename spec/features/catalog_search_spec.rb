feature 'Catalog search' do
  describe 'publications search' do
    let(:search_term) { 'fish' }
    background do
      visit root_path
      fill_in I18n.t('ddf.search.form.placeholder.publications'), with: search_term
      click_button 'search-publications'
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
      let(:search_term) { '0000-0003-2461-507X' }
      it 'should retrieve publications' do
        # Todo - fix problem with data in test index
        #expect(page).to have_content 'Linear Logic by Levels and Bounded Time Complexity'
      end
      it 'should not retrieve researchers' do
        expect(page).not_to have_content 'Thomas Haagen Birch'
      end
    end

    describe 'cris search' do
      let(:search_term) { '80ef6100-b171-4ef2-8370-265dbd7b57a2' }
      it 'should retrieve publications with this cris id' do
        expect(page).to have_content 'Eosinofil akut lymfatisk leukæmi hos yngre mand hjemvendt fra rejse i troperne'
      end
    end
  end
end
