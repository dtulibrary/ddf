require "minitest_helper"

describe "Pages integration" do

  describe "tests for navigating pages by visiting programmatically constructed links" do
    it "visits a facet page through accessible chart" do
      visit '/'
      page.text.must_include "Publications by Type"

      # click a facet
      find('ul.chartlist.types').find("a[href$='=dja']").click

      path_to_link  = 'ul.applied-filters-list li.applied-filter a.remove'
      path_to_label = 'ul.applied-filters-list li.applied-filter a.remove span.sr-only'

      page.has_css?(path_to_label).must_equal true
      page.find(path_to_label).text.must_equal 'Remove constraint Type: Journal article'

      # A bit of redundancy:
      page.has_content?('Remove constraint Type: Journal article').must_equal true
      page.has_content?('foobar').must_equal false

      # back to index page
      find(path_to_link).click

      page.text.must_include "Publications by Type"
    end
  end

end
