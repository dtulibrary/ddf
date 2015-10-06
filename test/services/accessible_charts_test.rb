# require 'minitest_helper'
include StatService

# include Blacklight::Solr
# include Blacklight::Catalog

describe "testing the statistics service" do
  it "returns an array from a Solr call" do
    # data = raw_data_for('source_ss')
    # TEST FOR:
    # type is Array
    # equal number of strings and numbers (data integrity)
  end

  it "preserves the order of an array of hashes when whitelisting" do
    list = [
      { label: 'foo', code: 'bar' },
      { label: 'foo', code: 'do' },
      { label: 'quux', code: 'baz' }
    ]
    whitelisted = [
      { label: 'foo', code: 'bar' },
      { label: 'quux', code: 'baz' }
    ]
    whitelist(list).must_equal whitelisted
  end
end
