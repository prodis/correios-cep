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
        let(:xml) do
          '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '<soap:Body>' +
              '<ns2:consultaCEPResponse xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">' +
                '<return>' +
                  '<bairro>Cavaleiro</bairro>' +
                  '<cep>54250610</cep>' +
                  '<cidade>Jaboatão dos Guararapes</cidade>' +
                  '<complemento></complemento>' +
                  '<complemento2></complemento2>' +
                  '<end>Rua Fernando Amorim</end>' +
                  '<id>0</id>' +
                  '<uf>PE</uf>' +
                '</return>' +
              '</ns2:consultaCEPResponse>' +
            '</soap:Body>' +
          '</soap:Envelope>'
        end

        it 'returns address' do
          expect(subject.hash(xml)).to eq expected_address
        end
      end

      context 'and has one complement' do
        let(:xml) do
          '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '<soap:Body>' +
              '<ns2:consultaCEPResponse xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">' +
                '<return>' +
                  '<bairro>Cavaleiro</bairro>' +
                  '<cep>54250610</cep>' +
                  '<cidade>Jaboatão dos Guararapes</cidade>' +
                  '<complemento>de 1500 até o fim</complemento>' +
                  '<complemento2></complemento2>' +
                  '<end>Rua Fernando Amorim</end>' +
                  '<id>0</id>' +
                  '<uf>PE</uf>' +
                '</return>' +
              '</ns2:consultaCEPResponse>' +
            '</soap:Body>' +
          '</soap:Envelope>'
        end

        it 'returns address' do
          expected_address[:complement] = 'de 1500 até o fim'

          expect(subject.hash(xml)).to eq expected_address
        end
      end

      context 'and has two complements' do
        let(:xml) do
          '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '<soap:Body>' +
              '<ns2:consultaCEPResponse xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">' +
                '<return>' +
                  '<bairro>Cavaleiro</bairro>' +
                  '<cep>54250610</cep>' +
                  '<cidade>Jaboatão dos Guararapes</cidade>' +
                  '<complemento>de 1500 até o fim</complemento>' +
                  '<complemento2>(zona mista)</complemento2>' +
                  '<end>Rua Fernando Amorim</end>' +
                  '<id>0</id>' +
                  '<uf>PE</uf>' +
                '</return>' +
              '</ns2:consultaCEPResponse>' +
            '</soap:Body>' +
          '</soap:Envelope>'
        end

        it 'returns address' do
          expected_address[:complement] = 'de 1500 até o fim (zona mista)'

          expect(subject.hash(xml)).to eq expected_address
        end
      end
    end

    context 'when address is not found' do
      let(:xml) do
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
          '<soap:Body>' +
            '<soap:Fault>' +
              '<faultcode>soap:Server</faultcode>' +
              '<faultstring>CEP NAO ENCONTRADO</faultstring>' +
              '<detail>' +
                '<ns2:SigepClienteException xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">CEP NAO ENCONTRADO</ns2:SigepClienteException>' +
              '</detail>' +
            '</soap:Fault>' +
          '</soap:Body>' +
        '</soap:Envelope>'
      end

      it 'returns empty hash' do
        expect(subject.hash(xml)).to eq({})
      end
    end
  end
end
