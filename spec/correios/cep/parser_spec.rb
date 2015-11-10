# encoding: UTF-8
require 'spec_helper'

describe Correios::CEP::Parser do
  describe '#address' do
    let(:expected_address) do
      address = Correios::CEP::Address.new
      address.street_address = 'Rua Fernando Amorim'
      address.neighborhood = 'Cavaleiro'
      address.city = 'Jaboatão dos Guararapes'
      address.state = 'PE'
      address.zipcode = '54250610'
      address
    end

    context 'when address is found' do
      let(:xml) { Fixture.load(:address) }

      it 'returns address' do
        expect(subject.address(xml)).to eq expected_address
      end
    end

    context 'when address is not found' do
      let(:xml) { Fixture.load(:address_not_found) }

      it 'returns nil' do
        expect(subject.address(xml)).to eq nil
      end
    end

    context 'when there is an unexpected error' do
      { invalid_zipcode: 'BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS',
        required_zipcode: 'CEP NAO INFORMADO',
        whatever_error: 'QUALQUER OUTRO ERRO',
        empty_response: 'Unknown error'
      }.each do |name, message|
        it 'raises RuntimeError exception' do
          xml = Fixture.load(name)
          expect { subject.address(xml) }.to raise_error(RuntimeError, message)
        end
      end
    end
  end

  describe '#hash' do
    let(:expected_address) do
      {
        address: 'Rua Fernando Amorim',
        neighborhood: 'Cavaleiro',
        city: 'Jaboatão dos Guararapes',
        state: 'PE',
        zipcode: '54250610',
        complement: ''
      }
    end

    context 'when address is found' do
      context 'and does not have complement' do
        let(:xml) { Fixture.load(:address) }

        it 'returns address' do
          expect(subject.hash(xml)).to eq expected_address
        end
      end

      context 'and has one complement' do
        let(:xml) { Fixture.load(:address_with_complement) }

        it 'returns address' do
          expected_address[:complement] = 'de 1500 até o fim'

          expect(subject.hash(xml)).to eq expected_address
        end
      end

      context 'and has two complements' do
        let(:xml) { Fixture.load(:address_with_two_complements) }

        it 'returns address' do
          expected_address[:complement] = 'de 1500 até o fim (zona mista)'

          expect(subject.hash(xml)).to eq expected_address
        end
      end
    end

    context 'when address is not found' do
      let(:xml) { Fixture.load(:address_not_found) }

      it 'returns empty hash' do
        expect(subject.hash(xml)).to eq({})
      end
    end
  end
end
