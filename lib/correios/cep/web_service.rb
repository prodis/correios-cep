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
          .use(logging: {logger: Logger.new(STDOUT)})
          .headers('Content-Type' => CONTENT_TYPE_HEADER)
          .post(@uri.to_s, body: BODY_TEMPLATE % { zipcode: zipcode })
          .body
          .to_s
      end

      private

      def http_setup
        return HTTP.via(@proxy_uri.host, @proxy_uri.port) if @proxy_uri != ''
        HTTP
      end
    end
  end
end
