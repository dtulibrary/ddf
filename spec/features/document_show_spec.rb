feature 'Document show' do

  given(:params) {{ id: '2265702896' }}
  background do
    visit(solr_document_path(params))
  end

  scenario 'Checking correct show fields' do
    expect(page).to have_content /authors/i
    expect(page).to have_content /type/i
    expect(page).to have_content /affiliations/i
    expect(page).to have_content /language/i
    expect(page).to have_content /published in/i
    expect(page).to have_content /doi/i
    expect(page).to have_content /abstract/i
    expect(page).to have_content /main research area/i
    expect(page).to have_content /publication status/i
    expect(page).to have_content /review type/i
    expect(page).to have_content /submission year/i
    expect(page).to have_content /scientific level/i
    expect(page).to have_content /id/i
  end

end