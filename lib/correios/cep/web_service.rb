# frozen_string_literal: true
require 'net/https'
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
        http = build_http

        request = build_request(zipcode)
        Correios::CEP.log_request(request, uri.to_s)

        response = http.request(request)
        Correios::CEP.log_response(response)

        http.finish if http.started?

        response.body
      end

      private

      attr_reader :uri, :proxy_uri

      def build_http
        Net::HTTP.start(
          uri.host,
          uri.port,
          proxy_uri.host,
          proxy_uri.port,
          nil,
          nil,
          use_ssl: true,
          verify_mode: OpenSSL::SSL::VERIFY_NONE,
          open_timeout: Correios::CEP.request_timeout,
          read_timeout: Correios::CEP.request_timeout
        )
      end

      def build_request(zipcode)
        request = Net::HTTP::Post.new(uri.path)
        request['Content-Type'] = CONTENT_TYPE_HEADER
        request.body = BODY_TEMPLATE % { zipcode: zipcode }
        request
      end
    end
  end
end
