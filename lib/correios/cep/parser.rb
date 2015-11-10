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
        'complemento2' => :complement2
      }.freeze

      ADDRESS_NOT_FOUND_ERROR = 'CEP NAO ENCONTRADO'

      def address(xml)
        address = Address.parse(xml)
        return address if address.has_content?

        error_message = extract_error_message(xml)
        return nil if error_message == ADDRESS_NOT_FOUND_ERROR

        raise error_message || 'Unknown error'
      end

      def hash(xml)
        doc = Ox.parse(xml)

        return_node = find_node(doc.nodes, 'return')
        return {} if return_node.nil?

        address = {}
        return_node.nodes.each do |element|
          address[ADDRESS_MAP[element.name]] = text_for(element) if ADDRESS_MAP[element.name]
        end

        join_complements(address)
        address
      end

      private

      def extract_error_message(xml)
        return $1 if xml =~ /<faultstring>(.*)<\/faultstring>/
      end

      def find_node(nodes, name)
        node = nodes.last
        return nil unless node.is_a?(Ox::Element)
        return node if node.nil? || node.name == name

        find_node(node.nodes, name)
      end

      def text_for(element)
        element.text.to_s.force_encoding(Encoding::UTF_8)
      end

      def join_complements(address)
        address[:complement] += " #{address.delete(:complement2)}"
        address[:complement].strip!
      end
    end
  end
end
