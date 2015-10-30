require "spec_helper"

describe Correios::CEP::AddressFinder do
  context "with invalid cep" do
    it "should raise ArgumentError when cep is nil" do
      expect{ subject.get(nil) }.to raise_error(ArgumentError)
    end

    it "should raise ArgumentError when cep does not have a valid format" do
      expect{ subject.get("542506-10") }.to raise_error(ArgumentError)
    end
  end

  context "with valid cep" do
    let(:cep) { '54250610' }
    let(:web_service_response) { "<end>Rua Fernando Amorim</end>" }
    let(:address) { { address: "Rua Fernando Amorim" } }

    before do
      allow_any_instance_of(Correios::CEP::WebService).to receive(:request).with(cep){ web_service_response }
      allow_any_instance_of(Correios::CEP::Parser).to receive(:address).with(web_service_response){ address }
    end

    describe "#get" do
      it "returns address" do
        expect(subject.get(cep)).to eql address
      end
    end

    describe ".get" do
      it "returns address" do
        expect(Correios::CEP::AddressFinder.get(cep)).to eql address
      end
    end
  end
end
