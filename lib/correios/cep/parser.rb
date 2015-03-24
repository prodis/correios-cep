require 'ox'

module Correios
  module CEP
    class Parser
      ADDRESS_MAP = {
        'end'          => :address,
        'bairro'       => :neighborhood,
        'cidade'       => :city,
        'uf'           => :state,
        'cep'          => :zipcode,
        'complemento'  => :complement,
        'complemento2' => :complement2,
      }.freeze

      def address(xml)
        doc = Ox.parse(xml)
        return_node = find_node(doc.nodes, 'return')
        return if return_node.nil?

        address = {}
        return_node.nodes.each do |element|
          address[ADDRESS_MAP[element.name]] = element.text.to_s if ADDRESS_MAP[element.name]
        end

        join_complements(address)
        address
      end

      private

      def find_node(nodes, name)
        node = nodes.first
        return node if node.nil? || node.name == name

        find_node(node.nodes, name)
      end

      def join_complements(address)
        address[:complement] += " #{address.delete(:complement2)}"
        address[:complement].strip!
      end
    end
  end
end
