module Correios
  module CEP
    class AddressFinder
      def get(zipcode)
        response = web_service.request! zipcode
        parser.address response
      end

      private

      def web_service
        @web_service ||= Correios::CEP::WebService.new
      end

      def parser
        @parser ||= Correios::CEP::Parser.new
      end
    end
  end
end
