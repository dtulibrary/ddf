require "minitest_helper"

describe "Pages integration" do
  it "shows the home page" do
    visit '/'
    page.text.must_include "Publications by Type"
    first('ul.chartlist').first('li').find('a').click
    path = 'ul.applied-filters-list li.applied-filter.filter-format_orig_s span.constraint a.remove span.sr-only'
    page.has_content? 'Remove constraint Type: Journal article'
    page.has_content? 'foobar'
  end
end



