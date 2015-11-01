module Correios
  module CEP
    class AddressFinder
      def get(zipcode)
        zipcode = zipcode.to_s.strip
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

      def validate(zipcode)
        raise ArgumentError.new('zipcode is required') if zipcode.empty?
        raise ArgumentError.new('zipcode in invalid format (valid format: 00000-000)') unless zipcode.match(/\A\d{5}-?\d{3}\z/)
      end
    end
  end
end
