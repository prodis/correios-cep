# frozen_string_literal: true
describe Correios::CEP::WebService do
  let(:cep) { '54250610' }

  describe '#request', vcr: { cassette_name: 'correios_consulta_cep_ok' } do
    it 'returns HTTP response body from Correios web service' do
      result = subject.request(cep)
      expect(result).to include('Rua Fernando Amorim')
    end
  end
end
