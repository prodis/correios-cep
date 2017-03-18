# frozen_string_literal: true
module Correios
  module CEP
    module Config
      DEFAULT_REQUEST_TIMEOUT = 5 #seconds
      attr_writer :proxy_url, :request_timeout

      def proxy_url
        @proxy_url ||= ''
      end

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end
    end
  end
end
