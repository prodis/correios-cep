# frozen_string_literal: true
# require 'net/https'
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
        options = build_options(zipcode)
        request = build_request(options)
        # Correios::CEP.log_request(request, uri.to_s)

        response = perform_request(request, options)
        # Correios::CEP.log_response(response)

        response.body.to_s
      end

      private

      attr_reader :uri, :proxy_uri

      def perform_request(request, options)
        HTTP::Client.new.perform(request, options)
      end

      def build_request(options)
        HTTP::Client.new.build_request(:post, uri, options)
      end

      def build_options(zipcode)
        options = {
          headers: { 'Content-Type' => CONTENT_TYPE_HEADER },
          body: BODY_TEMPLATE % { zipcode: zipcode }
        }
        # if proxy_uri.host != '' && proxy_uri.port != ''
        #   options[:proxy] = {
        #     proxy_address:  proxy_uri.host,
        #     proxy_port:     proxy_uri.port
        #   }
        # end

        HTTP::Options.new(options)
      end
    end
  end
end
