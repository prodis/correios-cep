require 'nokogiri'

module Correios
  module CEP
    class Parser
      ADDRESS_MAP = {
        "end"          => :address,
        "bairro"       => :neighborhood,
        "cidade"       => :city,
        "uf"           => :state,
        "cep"          => :zipcode,
        "complemento"  => :complement,
        "complemento2" => :complement2,
      }.freeze

      def address(xml)
        result = Nokogiri::XML(xml).xpath("//return")
        return if result.nil? || result.empty?

        address = {}
        result.children.each do |element|
          address[ADDRESS_MAP[element.name]] = element.text if ADDRESS_MAP[element.name]
        end

        join_complements! address
        address
      end

      private

      def join_complements!(address)
        address[:complement] += " #{address.delete(:complement2)}"
        address[:complement].strip!
      end
    end
  end
end
