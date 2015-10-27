# encoding: UTF-8
require 'spec_helper'

describe Correios::CEP::Parser do
  describe "#address" do
    let(:expected_address) do
      {
        address: "Rua Fernando Amorim",
        neighborhood: "Cavaleiro",
        city: "Jaboatão dos Guararapes",
        state: "PE",
        zipcode: "54250610",
        complement: ""
      }
    end

    context "when address is found" do
      context "and does not have complement" do
        let(:xml) do
          "<?xml version='1.0' encoding='UTF-8'?>" +
          "<S:Envelope>" +
            "<S:Body>" +
              "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                "<return>" +
                  "<bairro>Cavaleiro</bairro>" +
                  "<cep>54250610</cep>" +
                  "<cidade>Jaboatão dos Guararapes</cidade>" +
                  "<complemento></complemento>" +
                  "<complemento2></complemento2>" +
                  "<end>Rua Fernando Amorim</end>" +
                  "<id>0</id>" +
                  "<uf>PE</uf>" +
                "</return>" +
              "</ns2:consultaCEPResponse>" +
            "</S:Body>" +
          "</S:Envelope>"
        end

        it "returns address" do
          expect(subject.address(xml)).to eq expected_address
        end
      end

      context 'and has one complement' do
        let(:xml) do
          "<?xml version='1.0' encoding='UTF-8'?>" +
          "<S:Envelope>" +
            "<S:Body>" +
              "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                "<return>" +
                  "<bairro>Cavaleiro</bairro>" +
                  "<cep>54250610</cep>" +
                  "<cidade>Jaboatão dos Guararapes</cidade>" +
                  "<complemento>de 1500 até o fim</complemento>" +
                  "<complemento2></complemento2>" +
                  "<end>Rua Fernando Amorim</end>" +
                  "<id>0</id>" +
                  "<uf>PE</uf>" +
                "</return>" +
              "</ns2:consultaCEPResponse>" +
            "</S:Body>" +
          "</S:Envelope>"
        end

        it "returns address" do
          expected_address[:complement] = "de 1500 até o fim"

          expect(subject.address(xml)).to eq expected_address
        end
      end

      context 'and has two complements' do
        let(:xml) do
          "<?xml version='1.0' encoding='UTF-8'?>" +
          "<S:Envelope>" +
            "<S:Body>" +
              "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                "<return>" +
                  "<bairro>Cavaleiro</bairro>" +
                  "<cep>54250610</cep>" +
                  "<cidade>Jaboatão dos Guararapes</cidade>" +
                  "<complemento>de 1500 até o fim</complemento>" +
                  "<complemento2>(zona mista)</complemento2>" +
                  "<end>Rua Fernando Amorim</end>" +
                  "<id>0</id>" +
                  "<uf>PE</uf>" +
                "</return>" +
              "</ns2:consultaCEPResponse>" +
            "</S:Body>" +
          "</S:Envelope>"
        end

        it "returns address" do
          expected_address[:complement] = "de 1500 até o fim (zona mista)"

          expect(subject.address(xml)).to eq expected_address
        end
      end
    end

    context 'when address is not found' do
      let(:xml) do
        "<?xml version='1.0' encoding='UTF-8'?>" +
        "<S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<S:Body>" +
            "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\"/>" +
          "</S:Body>" +
        "</S:Envelope>"
      end

      it "returns nil" do
        expect(subject.address(xml)).to be_nil
      end
    end

    context "when cep has invalid format" do
      let(:xml) do
        "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<soap:Fault>" +
              "<faultcode>soap:Server</faultcode>" +
              "<faultstring>BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS</faultstring>" +
              "<detail>" +
                "<ns2:SigepClienteException xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                  "BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS" +
                "</ns2:SigepClienteException>" +
              "</detail>" +
            "</soap:Fault>" +
          "</soap:Body>" +
        "</soap:Envelope>"
      end

      it "returns message of invalid format" do
        expect(subject.address(xml)).to eq("BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS")
      end
    end

    context "when cep was not nound" do
      let(:xml) do
        "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<soap:Fault>" +
              "<faultcode>soap:Server</faultcode>" +
              "<faultstring>CEP NAO ENCONTRADO</faultstring>" +
              "<detail>" +
                "<ns2:SigepClienteException xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                  "CEP NAO ENCONTRADO" +
                "</ns2:SigepClienteException>" +
              "</detail>" +
            "</soap:Fault>" +
          "</soap:Body>" +
        "</soap:Envelope>"
      end

      it "returns message of not found" do
        expect(subject.address(xml)).to eq("CEP NAO ENCONTRADO")
      end
    end

    context "when cep is empty" do
      let(:xml) do
        "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<soap:Fault>" +
              "<faultcode>soap:Server</faultcode>" +
              "<faultstring>CEP NAO INFORMADO</faultstring>" +
              "<detail>" +
                "<ns2:SigepClienteException xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
                  "CEP NAO INFORMADO" +
                "</ns2:SigepClienteException>" +
              "</detail>" +
            "</soap:Fault>" +
          "</soap:Body>" +
        "</soap:Envelope>"
      end

      it "returns message of empty cep" do
        expect(subject.address(xml)).to eq("CEP NAO INFORMADO")
      end
    end
  end
end
