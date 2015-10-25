module Correios
  module CEP
    class AddressFinder
      class CEPNotFound < RuntimeError ; end;
      class InvalidCEPFormat < RuntimeError ; end;

      def get(zipcode)
        response = web_service.request(zipcode)
        format_response parser.address(response)
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

      def format_response(response)
        case response
        when "CEP NAO ENCONTRADO" 
          raise CEPNotFound.new "" 
        when "BUSCA DEFINIDA COMO EXATA, 0 CEP DEVE TER 8 DIGITOS" 
          raise InvalidCEPFormat.new "" 
        when "CEP NAO INFORMADO"
          raise CEPNotFound.new "" 
        else
          response
        end
      end
    end
  end
end
