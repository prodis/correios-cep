# frozen_string_literal: true
require 'http'
require 'uri'

module Correios
  module CEP
    class WebService
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
      HTTP_HEADERS = {
        'Content-Type' => 'text/xml; charset=utf-8',
        'User-Agent' => "correios-cep/#{Correios::CEP::VERSION}"
      }.freeze

      def request(zipcode)
        response = http.post(Correios::CEP.web_service_url,
                             body: request_body(zipcode),
                             ssl_context: ssl_context)
        response.body.to_s
      end

      private

      def http
        http = HTTP.headers(HTTP_HEADERS)
                   .timeout(
                      connect: Correios::CEP.request_timeout,
                      read: Correios::CEP.request_timeout
                   )
        http = http_proxy(http)
        http = http_log(http)

        http
      end

      def http_proxy(http)
        return http if proxy_uri.nil?

        http.via(proxy_uri.host, proxy_uri.port)
      end

      def http_log(http)
        return http if Correios::CEP.logger.nil?

        http.use(logging: { logger: Correios::CEP.logger })
      end

      def request_body(zipcode)
        BODY_TEMPLATE % { zipcode: zipcode }
      end

      def ssl_context
        context = OpenSSL::SSL::SSLContext.new
        context.verify_mode = OpenSSL::SSL::VERIFY_NONE
        context
      end

      def proxy_uri
        return nil if Correios::CEP.proxy_url.nil?

        @proxy_uri ||= URI.parse(Correios::CEP.proxy_url)
      end
    end
  end
end
