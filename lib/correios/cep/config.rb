module Correios
  module CEP
    module Config
      DEFAULT_REQUEST_TIMEOUT = 5 #seconds
      DEFAULT_MAX_RETRIES = 3
      attr_writer :proxy_url, :request_timeout, :max_retries

      def proxy_url
        @proxy_url ||= ''
      end

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end

      def max_retries
        @max_retries ||= DEFAULT_MAX_RETRIES
      end
    end
  end
end
