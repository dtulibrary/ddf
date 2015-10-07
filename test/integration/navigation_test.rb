require "minitest_helper"

describe "Pages integration" do
  it "shows the home page" do
    visit '/'
    page.text.must_include "million"
  end
end
