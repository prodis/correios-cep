require 'spec_helper'

describe Correios::CEP::WebService do
  let(:cep) { '54250610' }

  describe '#request', vcr: { cassette_name: 'correios_consulta_cep_ok' } do
    around do |example|
      Correios::CEP.log_enabled = false
      example.run
      Correios::CEP.log_enabled = true
    end

    context 'when Correios response is successful' do
      it 'returns HTTP response body from Correios web service' do
        result = subject.request(cep)
        expect(result).to include('Rua Fernando Amorim')
      end
    end
  end

  describe '#request without VCR' do
    before { VCR.turn_off! }
    after { VCR.turn_on! }

    around do |example|
      Correios::CEP.log_enabled = false
      example.run
      Correios::CEP.log_enabled = true
    end

    context 'when Correios drop packets' do
      it 'throws an exception after 3 retries' do
        stub_request(:post, /apps.correios.com.br/).to_raise(EOFError)
                                                   .then.to_raise(EOFError)
                                                   .then.to_raise(EOFError)

        expect { subject.request(cep) }.to raise_error(EOFError)
      end
    end
  end
end
