include StatService

describe "testing the statistics / data visualization module" do

  describe "the format of data served by Solr" do
    before do
      @data = raw_data_for('source_ss')
    end

    it "returns an array from a Solr call" do
      @data.class.must_equal Array
    end

    it "contains an equal number of numbers and strings" do
      numbers = @data.select { |el| el.class.eql? Fixnum }
      strings = @data - numbers
      numbers.length.must_equal strings.length
    end
  end

  describe "random Ruby goodness" do
    before do
      @list = [
        { label: 'foo', code: 'bar' },
        { label: 'foo', code: 'do' },
        { label: 'quux', code: 'baz' }
      ]
      @whitelisted = [
        { label: 'foo', code: 'bar' },
        { label: 'quux', code: 'baz' }
      ]
    end

    it "(Ruby, yay) preserves the order of an array when whitelisting" do
      whitelist(@list).must_equal @whitelisted
    end
  end

end
