require 'log-me'

module Correios
  module CEP
    extend LogMe

    module Timeout
      DEFAULT_REQUEST_TIMEOUT = 5 #seconds
      attr_writer :request_timeout

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end
    end

    extend Timeout
  end
end
