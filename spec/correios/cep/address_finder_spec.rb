require 'spec_helper'

describe Correios::CEP::AddressFinder do
  let(:cep) { "54250610" }
  let(:web_service_response) { "<end>Rua Fernando Amorim</end>" }
  let(:address) { { address: "Rua Fernando Amorim" } }

  before do
    Correios::CEP::WebService.any_instance.stub(:request!).with(cep).and_return(web_service_response)
    Correios::CEP::Parser.any_instance.stub(:address).with(web_service_response).and_return(address)
  end

  describe "#get" do
    it "returns address" do
      expect(subject.get(cep)).to eq address
    end
  end

  describe ".get" do
    it "returns address" do
      expect(Correios::CEP::AddressFinder.get(cep)).to eq address
    end
  end
end
