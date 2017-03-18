# frozen_string_literal: true
module Correios
  module CEP
    module Config
      WEB_SERVICE_URL = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'
      DEFAULT_REQUEST_TIMEOUT = 5 #seconds

      attr_writer :web_service_url, :proxy_url, :request_timeout

      def web_service_url
        @web_service_url ||= WEB_SERVICE_URL
      end

      def proxy_url
        @proxy_url ||= ''
      end

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end
    end
  end
end
