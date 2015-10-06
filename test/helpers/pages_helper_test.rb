require "minitest_helper"

describe PagesHelper do
  it "builds valid links given a facet name" do
    # http://localhost:3000/en/catalog?f[format_orig_s][]=dja
    facet = {
      :name=>"format_orig_s",
      :code=>"dja",
      :label=>"Tidsskrift-artikel",
      :count=>415394,
      :pct=>100.0
    }
    link = render_link_to(facet)
    link.must_equal "<a href=\"/catalog?f%5Bformat_orig_s%5D%5B%5D=dja\">Tidsskrift-artikel</a>"
    # This is URL-encoded from:
    # link.must_equal "<a href=\"/catalog?[format_orig_s][]=dja\">Tidsskrift-artikel</a>"
  end
end
