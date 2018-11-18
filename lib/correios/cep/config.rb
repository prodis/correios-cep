# frozen_string_literal: true
module Correios
  module CEP
    module Config
      WEB_SERVICE_URL = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'
      DEFAULT_REQUEST_TIMEOUT = 5 # seconds

      attr_accessor :logger, :proxy_url
      attr_writer :request_timeout, :web_service_url

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end

      def web_service_url
        @web_service_url ||= WEB_SERVICE_URL
      end

      def configure
        yield self if block_given?
      end
    end
  end
end
