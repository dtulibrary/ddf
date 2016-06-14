feature 'Catalog search' do
  include_context 'common'

  feature 'journal title highlighting' do
    background do
      visit root_path
      fill_in I18n.t('ddf.search.form.placeholder.publications'), with: 'diabetic medicine'
      # stub out the default response with our fixture
      expect_any_instance_of(Net::HTTPResponse).to receive(:body).at_least(:once)
      .and_return(response_with_highlighting)
      click_button 'search-publications'
    end

    it 'contains the highlighted journal title' do
      expect(page.find_all('em', text: /diabetic/i).first).not_to be_nil
    end

    # we should only take the first variant
    it 'does not contain any variants of the journal title' do
      expect(page).not_to have_content 'Diab. Med'
    end
  end

  describe 'highlighting' do
    background do
      visit root_path
      fill_in I18n.t('ddf.search.form.placeholder.publications'), with: search_term
      click_button 'search-publications'
    end

    feature 'author highlighting' do
      let(:search_term) { 'Daniel' }
      it 'contains the highlighted author name' do
        expect(page.find_all('em', text: search_term).first).not_to be_nil
      end
    end

    feature 'abstract highlighting' do
      let(:search_term) { 'constant' }
      it 'contains a highlighted abstract' do
        expect(page.find_all('em', text: search_term).first).not_to be_nil
      end
    end

    feature 'publisher highlighting' do
      let(:search_term) { 'computing machinery' }
      it 'contains a highlighted publisher' do
        expect(page.find_all('em', text: 'computing').first).not_to be_nil
      end
    end
  end
end
