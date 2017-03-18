# frozen_string_literal: true
require 'spec_helper'

describe Correios::CEP::WebService do
  let(:cep) { '54250610' }

  describe '#request', vcr: { cassette_name: 'correios_consulta_cep_ok' } do
    around do |example|
      Correios::CEP.log_enabled = false
      example.run
      Correios::CEP.log_enabled = true
    end

    it 'returns HTTP response body from Correios web service' do
      result = subject.request(cep)
      expect(result).to include('Rua Fernando Amorim')
    end
  end
end
