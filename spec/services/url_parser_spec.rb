require 'rails_helper'

RSpec.describe UrlParser, type: :model do
  describe '.trim_url' do
    it 'removes scheme/protocol part from the url' do
      expect(UrlParser.trim_url('http://www.wp.pl')).to eq('wp.pl')
    end

    it 'normalizes url' do
      expect(UrlParser.trim_url('http://www.詹姆斯.com/')).to eq('xn--8ws00zhy3a.com')
    end

    it "doesnt change url when it's good" do
      expect(UrlParser.trim_url('www.wp.com')).to eq('wp.com')
    end

    it "doesnt change url when it's good" do
      expect(UrlParser.trim_url('http://example.com/path?param1=one&param2=2&param3=something3')).to eq('example.com')
    end

    context 'when url is invalid' do
      it "returns url with http added" do
        # It is invalid anyway
        expect(UrlParser.trim_url('asdfadfafaf')).to eq('http://asdfadfafaf')
      end
    end
  end
end
