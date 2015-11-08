# encoding: UTF-8
require 'spec_helper'

describe Correios::CEP::Address do
  describe '#==' do
    subject do
      address = described_class.new
      address.street_address = 'Rua Fernando Amorim'
      address.neighborhood = 'Cavaleiro'
      address.city = 'Jaboatão dos Guararapes'
      address.state = 'PE'
      address.zipcode = '54250610'
      address.complement = 'de 1500 até o fim'
      address == other_address
    end

    context 'when two instances have the same state' do
      let(:other_address) do
        address = described_class.new
        address.street_address = 'Rua Fernando Amorim'
        address.neighborhood = 'Cavaleiro'
        address.city = 'Jaboatão dos Guararapes'
        address.state = 'PE'
        address.zipcode = '54250610'
        address.complement = 'de 1500 até o fim'
        address
      end

      it { should be true }
    end

    context 'when two instances does not have the same state' do
      let(:other_address) do
        address = described_class.new
        address.street_address = 'Rua José Amorim'
        address.neighborhood = 'Jardim Ouro Preto'
        address.city = 'Nova Friburgo'
        address.state = 'RJ'
        address.zipcode = '28633050'
        address.complement = ''
        address
      end

      it { should be false }
    end
  end

  describe '#has_content?' do
    context 'when address has content' do
      subject do
        address = described_class.new
        address.street_address = 'Rua Fernando Amorim'
        address.neighborhood = 'Cavaleiro'
        address.city = 'Jaboatão dos Guararapes'
        address.state = 'PE'
        address.zipcode = '54250610'
        address.has_content?
      end

      it { should be true }
    end

    context 'when address does not have content' do
      subject do
        address = described_class.new
        address.has_content?
      end

      it { should be false }
    end
  end
end
