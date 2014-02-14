require 'net/http'
require 'uri'

module Correios
  module CEP
    class WebService
      URL = "http://200.252.60.209/SigepCliente/AtendeClienteService"

      def initialize
        @uri = URI.parse(URL)
      end

      def request!(zipcode)
        http = build_http

        request = build_request zipcode
        log_request request

        response = http.request request
        log_response response

        response.body
      end

      private

      def build_http
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.open_timeout = Correios::CEP.request_timeout
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

      def log_request(request)
        message = format_message(request) do
          message =  with_line_break { "Correios-CEP Request:" }
          message << with_line_break { "POST #{URL}" }
        end

        Correios::CEP.log(message)
      end

      def log_response(response)
        message = format_message(response) do
          message =  with_line_break { "Correios-CEP Response:" }
          message << with_line_break { "HTTP/#{response.http_version} #{response.code} #{response.message}" }
        end

        Correios::CEP.log(message)
      end

      def format_message(http)
        message = yield
        message << with_line_break { http.body }
      end

      def with_line_break
        "#{yield}\n"
      end
    end
  end
end
