require "minitest_helper"
require 'addressable/uri'

describe PagesHelper do
  it "builds valid links given a facet name" do
    # http://localhost:3000/en/catalog?f[format_orig_s][]=dja
    facet = {
      :name  => "format_orig_s",
      :code  => "dja",
      :label => "Tidsskrift-artikel",
      :count => 415394,
      :pct   => 100.0
    }

    url = '/catalog?f[format_orig_s][]=dja'
    escaped = Addressable::URI.escape(url)

    link = render_link_to(facet)
    link.must_equal "<a href=\"#{escaped}\">Tidsskrift-artikel</a>"
  end
end
