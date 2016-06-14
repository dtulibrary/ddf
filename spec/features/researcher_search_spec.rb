feature 'Researcher search' do
  let(:search_term) { 'Jens' }
  background do
    visit root_path
    fill_in I18n.t('ddf.search.form.placeholder.researchers'), with: search_term
    click_button 'search-researchers'
  end

  scenario 'name search' do
    expect(page).to have_content search_term
    # Should be a status: active facet on per default
    within 'ul.applied-filters-list' do
      expect(page).to have_content 'Status: Active'
    end
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

  describe 'orcid search' do
    let(:search_term) { '0000-0001-6296-3310' }
    it 'should retrieve the correct researcher' do
      expect(page).to have_content 'Mette Bak-Andersen'
    end
  end
  describe 'cris search' do
    let(:search_term) { 'bd876eba-edd3-45bd-a37f-b9e7ff1cd99e' }
    it 'should find the correct researcher' do
      pending 'Requires work in Metastore to add cris ids to researchers'
      expect(page).to have_content 'Mette Bak-Andersen'
    end
  end
end
