require 'net/https'
require 'uri'

module Correios
  module CEP
    class WebService
      URL = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'.freeze

      def initialize
        @uri = URI.parse(URL)
        @proxy_uri = URI.parse(Correios::CEP.proxy_url)
      end

      def request(zipcode)
        http = build_http

        response = request_with_retry { http.request(build_request(zipcode)) }

        response.body
      ensure
        http.finish if http.started?
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
        request['Content-Type'] = 'text/xml; charset=utf-8'
        request.body = request_body(zipcode)
        Correios::CEP.log_request(request, uri.to_s)

        request
      end

      def request_body(zipcode)
        '<?xml version="1.0" encoding="UTF-8"?>' \
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">' \
           '<soapenv:Header />' \
           '<soapenv:Body>' \
              '<cli:consultaCEP>' \
                "<cep>#{zipcode}</cep>" \
              '</cli:consultaCEP>' \
           '</soapenv:Body>' \
        '</soapenv:Envelope>'
      end

      def request_with_retry
        retries ||= 0
        response = yield
        Correios::CEP.log_response(response)
        response
      rescue EOFError
        retry if (retries += 1) < Correios::CEP.max_retries || raise
      end
    end
  end
end
