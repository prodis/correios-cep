# encoding: UTF-8
require 'spec_helper'

describe Correios::CEP::Parser do
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
