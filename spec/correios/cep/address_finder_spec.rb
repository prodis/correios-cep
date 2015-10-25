require 'spec_helper'

describe Correios::CEP::AddressFinder do

  context "when address is valid" do
    let(:cep) { '54250610' }
    let(:web_service_response) { '<end>Rua Fernando Amorim</end>' }
    let(:address) { { address: 'Rua Fernando Amorim' } }

    before do
      allow_any_instance_of(Correios::CEP::WebService).to receive(:request).with(cep){ web_service_response }
      allow_any_instance_of(Correios::CEP::Parser).to receive(:address).with(web_service_response){ address }
    end

    describe '#get' do
      it 'returns address' do
        expect(subject.get(cep)).to eql address
      end
    end

    describe '.get' do
      it 'returns address' do
        expect(Correios::CEP::AddressFinder.get(cep)).to eql address
      end
    end
  end

  context "when address is not valid" do
    before do
      allow_any_instance_of(Correios::CEP::WebService).to receive(:request)
    end

    it "raises CEPNotFound when cep is empty" do
      allow_any_instance_of(Correios::CEP::Parser).to receive(:address){ "CEP NAO INFORMADO" }
      expect{ subject.get("") }.to raise_error(Correios::CEP::AddressFinder::CEPNotFound)
    end

    it "raises CEPNotFound when cep was not found" do
      allow_any_instance_of(Correios::CEP::Parser).to receive(:address){ "CEP NAO ENCONTRADO" }
      expect{ subject.get("") }.to raise_error(Correios::CEP::AddressFinder::CEPNotFound)
    end

    it "raises InvalidCEPFormat when cep has invalid format" do
      allow_any_instance_of(Correios::CEP::Parser).to receive(:address){ "BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS" }
      expect{ subject.get("") }.to raise_error(Correios::CEP::AddressFinder::InvalidCEPFormat)
    end
  end
end
