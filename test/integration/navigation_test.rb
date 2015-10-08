require "minitest_helper"

describe "Pages integration" do
  it "shows the home page" do
    visit '/'
    page.text.must_include "Publications by Type"
    first('ul.chartlist').first('li').find('a').click
    path = 'ul.applied-filters-list li.applied-filter.filter-format_orig_s span.constraint a.remove span.sr-only'
    page.has_selector?(path).must_equal true
    page.has_xpath?(path).must_equal true
    page.has_content?('Remove constraint Type: Journal article').must_equal true
    page.has_content?('foobar').must_equal false
  end
end



