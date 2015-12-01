Capybara.javascript_driver = :webkit

feature 'bookmarks' do 
  background do
    visit root_path
    fill_in 'Search...', with: 'fish'
    click_button 'Search'
  end
  let (:bookmark_absent_label) { I18n.t('blacklight.search.bookmarks.absent') }
  let (:bookmark_selected_label) { I18n.t('blacklight.search.bookmarks.present') }
  scenario 'bookmarking a document adds it to bookmarks', js: true do
    expect(page).to have_content(bookmark_absent_label)
    checkbox = page.first('input.toggle_bookmark')
    doctitle = page.first('h5.doctitle').text 
    check(checkbox['id'])
    expect(page).to have_content(bookmark_selected_label)
    visit bookmarks_path
    expect(page).to have_content(doctitle)
 end
end