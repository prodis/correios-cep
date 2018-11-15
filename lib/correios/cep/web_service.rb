# frozen_string_literal: true
require 'http'
require 'uri'

module Correios
  module CEP
    class WebService
      CONTENT_TYPE_HEADER = 'text/xml; charset=utf-8'
      BODY_TEMPLATE = '<?xml version="1.0" encoding="UTF-8"?>' \
                      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' \
                      ' xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">' \
                         '<soapenv:Header />' \
                         '<soapenv:Body>' \
                            '<cli:consultaCEP>' \
                              '<cep>%{zipcode}</cep>' \
                            '</cli:consultaCEP>' \
                         '</soapenv:Body>' \
                      '</soapenv:Envelope>'

      def initialize
        @uri = URI.parse(Correios::CEP.web_service_url)
        @proxy_uri = URI.parse(Correios::CEP.proxy_url)
      end

      def request(zipcode)
        http_setup
          .post(@uri.to_s, body: request_body(zipcode), ssl_context: ssl_setup)
          .body
          .to_s
      end

      private

      def client
        @proxy_uri.host ? HTTP.via(@proxy_uri.host, @proxy_uri.port) : HTTP
      end

      def http_setup
        client
          .timeout(connect: Correios::CEP.request_timeout)
          .use(logging: {logger: Correios::CEP.logger})
          .headers('Content-Type' => CONTENT_TYPE_HEADER)
      end

      def request_body(zipcode)
        BODY_TEMPLATE % { zipcode: zipcode }
      end

      def ssl_setup
        ssl = OpenSSL::SSL::SSLContext.new
        ssl.verify_mode = OpenSSL::SSL::VERIFY_NONE
        ssl
      end
    end
  end
end
