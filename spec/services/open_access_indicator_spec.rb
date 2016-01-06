describe OpenAccessIndicator do
  describe 'fetch' do
    context 'invalid parameters' do
      subject { OpenAccessIndicator.fetch('bla', 'bla') }
      it { should eql nil }
    end
  end

  describe OpenAccessIndicator::Response do
    subject  { OpenAccessIndicator::Response.relative_values(response, resource) }
    describe 'relative_values' do
      context '(national)' do
        let(:resource) { 'national' }
        let(:response) {
          '{ "oa_indicator":{"response":{"datestamp":"2016-01-06 12:03:24","elapse":"0.009858","body":{"relative_clear":{"realized":23.1415420023015,"unused":76.8584579976985},"relative":{"unclear":20.7333759007571,"realized":18.3435191097327,"unused":60.9231049895102},"unclear":4546,"total_clear":17380,"realized":4022,"total":21926,"unused":13358}},"request":{"run":"latest","year":"2014","command":"national","type":"devel","format":"json","types":"prod,devel","success":1,"datestamp":"2016-01-06 12:03:24"}}}'
        }
        it 'should be keyed by resource' do
          expect(subject.keys).to eql ['national']
        end
        it 'should contain the correct values' do
          expect(subject['national'].to_s).to eql '{"unclear"=>20.7333759007571, "realized"=>18.3435191097327, "unused"=>60.9231049895102}'
        end
      end
      context '(universities)' do
        let(:resource) { 'universities' }
        let(:response) {
          '{"oa_indicator":{"response":{"datestamp":"2016-01-06 14:06:58","elapse":"0.000253","body":{"cbs":{"relative_clear":{"realized":6.2015503875969,"unused":93.7984496124031},"relative":{"unclear":28.3333333333333,"realized":4.44444444444444,"unused":67.2222222222222},"unclear":153,"total_clear":387,"realized":24,"total":540,"unused":363},"au":{"relative_clear":{"realized":16.6163141993958,"unused":83.3836858006042},"relative":{"unclear":20.8674863387978,"realized":13.1489071038251,"unused":65.983606557377},"unclear":1222,"total_clear":4634,"realized":770,"total":5856,"unused":3864},"sdu":{"relative_clear":{"realized":19.3701940681069,"unused":80.6298059318931},"relative":{"unclear":22.6345609065156,"realized":14.985835694051,"unused":62.3796033994334},"unclear":799,"total_clear":2731,"realized":529,"total":3530,"unused":2202},"itu":{"relative_clear":{"realized":21.3592233009709,"unused":78.6407766990291},"relative":{"unclear":17.6,"realized":17.6,"unused":64.8},"unclear":22,"total_clear":103,"realized":22,"total":125,"unused":81},"ruc":{"relative_clear":{"realized":41.1184210526316,"unused":58.8815789473684},"relative":{"unclear":28.4705882352941,"realized":29.4117647058824,"unused":42.1176470588235},"unclear":121,"total_clear":304,"realized":125,"total":425,"unused":179},"aau":{"relative_clear":{"realized":26.044703595724,"unused":73.955296404276},"relative":{"unclear":26.5,"realized":19.1428571428571,"unused":54.3571428571429},"unclear":742,"total_clear":2058,"realized":536,"total":2800,"unused":1522},"dtu":{"relative_clear":{"realized":35.4873259550161,"unused":64.5126740449839},"relative":{"unclear":12.249373433584,"realized":31.140350877193,"unused":56.6102756892231},"unclear":391,"total_clear":2801,"realized":994,"total":3192,"unused":1807},"ku":{"relative_clear":{"realized":21.2789243277048,"unused":78.7210756722952},"relative":{"unclear":18.7912646013205,"realized":17.2803453529711,"unused":63.9283900457085},"unclear":1480,"total_clear":6396,"realized":1361,"total":7876,"unused":5035}}},"request":{"run":"latest","year":"2014","command":"universities","type":"devel","format":"json","types":"prod,devel","success":1,"datestamp":"2016-01-06 14:06:58"}}}'
        }
        it 'should contain keys for the universities' do
          expect(subject.keys).to eql ['cbs', 'au', 'sdu', 'itu', 'ruc', 'aau', 'dtu', 'ku']
        end
        it 'should contain the relative values for each university' do
          expect(subject['cbs'].to_s).to eql '{"unclear"=>28.3333333333333, "realized"=>4.44444444444444, "unused"=>67.2222222222222}'
        end
      end
    end
  end
end
