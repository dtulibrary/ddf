describe OpenAccessIndicator do
  shared_context 'national' do
    let(:resource) { 'national' }
    let(:response) {
      '{ "oa_indicator":{"response":{"datestamp":"2016-01-06 12:03:24","elapse":"0.009858","body":{"relative_clear":{"realized":23.1415420023015,"unused":76.8584579976985},"relative":{"unclear":20.7333759007571,"realized":18.3435191097327,"unused":60.9231049895102},"unclear":4546,"total_clear":17380,"realized":4022,"total":21926,"unused":13358}},"request":{"run":"latest","year":"2014","command":"national","type":"devel","format":"json","types":"prod,devel","success":1,"datestamp":"2016-01-06 12:03:24"}}}'
    }
  end
  shared_context 'universities' do
    let(:resource) { 'universities' }
    let(:response) {
      '{"oa_indicator":{"response":{"datestamp":"2016-01-06 14:06:58","elapse":"0.000253","body":{"cbs":{"relative_clear":{"realized":6.2015503875969,"unused":93.7984496124031},"relative":{"unclear":28.3333333333333,"realized":4.44444444444444,"unused":67.2222222222222},"unclear":153,"total_clear":387,"realized":24,"total":540,"unused":363},"au":{"relative_clear":{"realized":16.6163141993958,"unused":83.3836858006042},"relative":{"unclear":20.8674863387978,"realized":13.1489071038251,"unused":65.983606557377},"unclear":1222,"total_clear":4634,"realized":770,"total":5856,"unused":3864},"sdu":{"relative_clear":{"realized":19.3701940681069,"unused":80.6298059318931},"relative":{"unclear":22.6345609065156,"realized":14.985835694051,"unused":62.3796033994334},"unclear":799,"total_clear":2731,"realized":529,"total":3530,"unused":2202},"itu":{"relative_clear":{"realized":21.3592233009709,"unused":78.6407766990291},"relative":{"unclear":17.6,"realized":17.6,"unused":64.8},"unclear":22,"total_clear":103,"realized":22,"total":125,"unused":81},"ruc":{"relative_clear":{"realized":41.1184210526316,"unused":58.8815789473684},"relative":{"unclear":28.4705882352941,"realized":29.4117647058824,"unused":42.1176470588235},"unclear":121,"total_clear":304,"realized":125,"total":425,"unused":179},"aau":{"relative_clear":{"realized":26.044703595724,"unused":73.955296404276},"relative":{"unclear":26.5,"realized":19.1428571428571,"unused":54.3571428571429},"unclear":742,"total_clear":2058,"realized":536,"total":2800,"unused":1522},"dtu":{"relative_clear":{"realized":35.4873259550161,"unused":64.5126740449839},"relative":{"unclear":12.249373433584,"realized":31.140350877193,"unused":56.6102756892231},"unclear":391,"total_clear":2801,"realized":994,"total":3192,"unused":1807},"ku":{"relative_clear":{"realized":21.2789243277048,"unused":78.7210756722952},"relative":{"unclear":18.7912646013205,"realized":17.2803453529711,"unused":63.9283900457085},"unclear":1480,"total_clear":6396,"realized":1361,"total":7876,"unused":5035}}},"request":{"run":"latest","year":"2014","command":"universities","type":"devel","format":"json","types":"prod,devel","success":1,"datestamp":"2016-01-06 14:06:58"}}}'
    }
  end
  shared_context 'status_api' do
    let(:response) { "<?xml version=\"1.0\"?><oa_indicator><request><command>status</command><datestamp>2016-01-18 13:49:54</datestamp><format>xml (default)</format></request><response><body><title>OA-Indicator</title><years><year val=\"2013\"><types><test><runs><run val=\"3\"><description>New test run with hopefully the last changes to the spreadsheet</description><end>#{tstamp1}</end><errors></errors><released>1</released><start>1452867807</start><success>1</success></run></runs></test></types></year><year val=\"2014\"><types><devel><runs><run val=\"2\"><description>First candidate for production run.</description><end>1451907420</end><errors></errors><released>1</released><start>1451901974</start><success>1</success></run></runs></devel><test><runs><run val=\"3\"><description>New test run with hopefully the last changes to the spreadsheet</description><end>#{tstamp2}</end><errors></errors><released>1</released><start>1452867325</start><success>1</success></run></runs></test></types></year></years></body><datestamp>2016-01-18 13:49:54</datestamp><elapse>0.004942</elapse></response></oa_indicator>" }
    let(:tstamp1) { '1452869008' }
    let(:tstamp2) { '1452869002' }
  end
  shared_context 'caching' do
    include_context 'status_api'
    let(:dir_path_1) {'tmp/open_access/2013' }
    let(:dir_path_2) {'tmp/open_access/2014' }
    let(:cache_1) { "#{dir_path_1}/#{tstamp1}"}
    let(:cache_2) { "#{dir_path_2}/#{tstamp2}"}
    before do
      FileUtils.mkdir_p(dir_path_1)
      FileUtils.mkdir_p(dir_path_2)
      File.open(cache_1, 'w') {}
      File.open(cache_2, 'w') {}
    end
    after do
      FileUtils.rm(cache_1)
      FileUtils.rm(cache_2)
    end
  end
  shared_context 'valid_cache' do
    include_context 'caching'
  end
  shared_context 'invalid_cache' do
    include_context 'caching'
    let(:tstamp1) { '1452869000' }
    let(:tstamp2) { '1452869000' }
  end

  describe 'report_urls' do
    subject { OpenAccessIndicator.report_urls(year, lang) }
    let(:year) { '2014' }
    let (:lang) { I18n.default_locale }
    it { should be_a Hash }
    it 'should have values eql to the report types' do
      expect(subject.keys).to eql OpenAccessIndicator::REPORTS
    end
    it 'should contain urls with the correct year, language and profile' do
      expect(subject.values.first).to include 'http'
      expect(subject.values.first).to include year
      expect(subject.values.first).to include 'eng'
      expect(subject.values.first).to include OpenAccessIndicator.profile
    end
  end

  describe 'fetch' do
    subject { OpenAccessIndicator.fetch(*params) }
    context 'with invalid parameters' do
      let(:params) { ['bla', 'bla']}
      it { should eql nil }
    end
    context 'with an out of range year' do
      let(:params){['national', '2015']}
      it { should eql nil }
    end
    context 'with valid parameters' do
      let(:params){['national', '2013']}
      context 'when there is a cached copy' do
        include_context 'valid_cache'
        it 'does not make a request to the resource url' do
          pending 'putting caching on hold for now'
          expect(OpenAccessIndicator).not_to receive(:resource_url)
          OpenAccessIndicator.fetch(*params)
        end
      end
      context 'when there is an invalid cache' do
        it 'makes a new request to the resource url'
      end
    end
  end
  describe 'timeline' do
    subject { OpenAccessIndicator.timeline('national', 'national') }
    include_context 'national'
    it 'should be keyed by resource' do
      expect(subject.keys).to eql ['national']
    end
    it 'should contain keys for each indicator year' do
      expect(subject['national'].keys).to include '2014'
    end
    it 'should contain absolute and relative values for each year' do
      expect(subject['national']['2014'].keys).to include 'absolute'
      expect(subject['national']['2014'].keys).to include 'relative'
    end
    it 'should contain the correct values' do
      # Stub out the API request so we always get the sample response above
      allow_any_instance_of(Net::HTTPOK).to receive(:body).and_return(response)
      expect(subject['national']['2014']['relative']).to eql 18.3435191097327
      expect(subject['national']['2014']['absolute']).to eql 4022
    end
  end

  describe OpenAccessIndicator::LocalCache do
    describe 'update_needed?' do
      include_context 'status_api'
      subject { OpenAccessIndicator::LocalCache.update_needed? }
      context 'when nothing is cached' do
        it { should eql true }
      end
      context 'when there is a cached copy with the same timestamp as given by the API' do
        include_context 'valid_cache'
        it { should eql false }
      end
      context 'when there is a cached copy with another timestamp' do
        include_context 'invalid_cache'
        it { should eql true }
      end
    end
    describe 'read_latest' do
      subject { OpenAccessIndicator::LocalCache.read_latest(year) }
      context 'when there is valid cached data' do
        include_context 'valid_cache'
        let(:year) { '2014' }
        pending 'putting caching on hold for now'
        # it { should eql response }
      end
    end
  end

  describe OpenAccessIndicator::StatusResponse do
    include_context 'status_api'
    describe 'status' do
      subject { OpenAccessIndicator::StatusResponse.values(response, 'test') }
      it 'returns a hash of years and timestamps' do
        expect(subject.keys).to include '2014'
        expect(subject.keys).to include '2013'
        expect(subject['2014']).to eql '1452869002'
        expect(subject['2013']).to eql '1452869008'
      end
    end
  end

  describe OpenAccessIndicator::Response do

    describe 'timeline_values' do
      subject  { OpenAccessIndicator::Response.timeline_values(response, resource, key) }
      include_context 'national'
      let(:key) { 'national' }
      it 'should return a hash with relative and absolute keys' do
        expect(subject.keys).to include 'relative'
        expect(subject.keys).to include 'absolute'
      end
      it 'should contain the correct values' do
        expect(subject['relative']).to eql 18.3435191097327
        expect(subject['absolute']).to eql 4022
      end
    end

    describe 'relative_values' do
      subject  { OpenAccessIndicator::Response.values(response, resource, view) }
      let(:view) { 'relative' }
      context '(national)' do
        include_context 'national'
        it 'should be keyed by resource' do
          expect(subject.keys).to eql ['national']
        end
        it 'should contain the correct values' do
          expect(subject['national']['relative']['unclear']).to eql 20.7333759007571
          expect(subject['national']['relative']['realized']).to eql 18.3435191097327
          expect(subject['national']['relative']['unused']).to eql 60.9231049895102
        end
      end
      context '(universities)' do
        include_context 'universities'
        it 'should contain keys for the universities' do
          expect(subject.keys).to eql ['cbs', 'au', 'sdu', 'itu', 'ruc', 'aau', 'dtu', 'ku']
        end
        it 'should contain the relative values for each university' do
          expect(subject['cbs']['relative']['unclear']).to eql 28.3333333333333
          expect(subject['cbs']['relative']['realized']).to eql 4.44444444444444
          expect(subject['cbs']['relative']['unused']).to eql 67.2222222222222
        end
      end
    end
    describe 'relative_clear values' do
      subject  { OpenAccessIndicator::Response.values(response, resource, view) }
      let(:view) { 'relative_clear' }
      context('national') do
        include_context 'national'
        it 'should contain the correct values' do
          expect(subject['national'][view]['realized']).to eql 23.1415420023015
          expect(subject['national'][view]['unused']).to eql 76.8584579976985
        end
      end
    end
  end
end
