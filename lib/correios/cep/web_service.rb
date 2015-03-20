require 'net/https'
require 'uri'

module Correios
  module CEP
    class WebService
      URL = "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"

      def initialize
        @uri = URI.parse(URL)
      end

      def request!(zipcode)
        http = build_http

        request = build_request zipcode
        Correios::CEP.log_request request, @uri.to_s

        response = http.request request
        Correios::CEP.log_response response

        response.body
      end

      private

      def build_http
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.open_timeout = Correios::CEP.request_timeout
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def build_request(zipcode)
        request = Net::HTTP::Post.new(@uri.path)
        request["Content-Type"] = "text/xml; charset=utf-8"
        request.body = request_body zipcode
        request
      end

      def request_body(zipcode)
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cli=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" +
           "<soapenv:Header />" +
           "<soapenv:Body>" +
              "<cli:consultaCEP>" +
                "<cep>#{zipcode}</cep>" +
              "</cli:consultaCEP>" +
           "</soapenv:Body>" +
        "</soapenv:Envelope>"
      end
    end
  end
end
