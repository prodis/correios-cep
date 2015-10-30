module Correios
  module CEP
    class AddressFinder
      def get(zipcode)
        validate(zipcode)
        response = web_service.request(zipcode)
        parser.address(response)
      end

      def self.get(zipcode)
        self.new.get(zipcode)
      end

      private

      def web_service
        @web_service ||= Correios::CEP::WebService.new
      end

      def parser
        @parser ||= Correios::CEP::Parser.new
      end

      private

      def validate(zipcode)
        if zipcode.to_s.strip.empty? || !zipcode.to_s.match(/\A\d{5}-?\d{3}\z/)
          raise ArgumentError.new("invalid cep format")
        end
      end
    end
  end
end
