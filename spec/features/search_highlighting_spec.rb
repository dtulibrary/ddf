feature 'Catalog search' do

  feature 'journal title highlighting' do
    background do
      visit root_path
      fill_in 'Search...', with: 'diabetic medicine'
      click_button 'Search'
    end

    it 'contains the highlighted journal title' do
      expect(page.find_all('em', text: /diabetic/i).first).not_to be_nil
    end
  end

  feature 'author highlighting' do
    background do
      visit root_path
      fill_in 'Search...', with: 'jensen, jens'
      click_button 'Search'
    end

    it 'contains the highlighted author name' do
      expect(page.find_all('em', text: 'Jensen').first).not_to be_nil
    end
  end

  feature 'abstract highlighting' do
    background do
      visit root_path
      fill_in 'Search...', with: 'fish'
      click_button 'Search'
    end

    it 'contains a highlighted abstract' do
      expect(page.find_all('em', text: 'fish').first).not_to be_nil
    end
  end

  feature 'publisher highlighting' do
    background do
      visit root_path
      fill_in 'Search...', with: 'Blackwell'
      click_button 'Search'
    end

    it 'contains a highlighted publisher' do
      expect(page.find_all('em', text: 'Blackwell').first).not_to be_nil
    end
  end

end