# frozen_string_literal: true
describe Correios::CEP do
  describe '#web_service_url' do
    it 'default is Correios::CEP::Config::WEB_SERVICE_URL' do
      expect(Correios::CEP.web_service_url).to eq Correios::CEP::Config::WEB_SERVICE_URL
    end

    context 'when set web service URL' do
      let(:url) { 'http://ws.correios.com.br/cep' }

      around do |example|
        Correios::CEP.web_service_url = url
        example.run
        Correios::CEP.web_service_url = Correios::CEP::Config::WEB_SERVICE_URL
      end

      it 'returns the given web service URL' do
        expect(Correios::CEP.web_service_url).to eq url
      end
    end
  end

  describe "#request_timeout" do
    it "default is 5" do
      expect(Correios::CEP.request_timeout).to eq 5
    end

    context "when set timeout" do
      it "returns timeout" do
        Correios::CEP.request_timeout = 3
        expect(Correios::CEP.request_timeout).to eq 3
      end

      it "returns timeout in seconds (integer)" do
        Correios::CEP.request_timeout = 2.123
        expect(Correios::CEP.request_timeout).to eq 2
      end
    end
  end
end
