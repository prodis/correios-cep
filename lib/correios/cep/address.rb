module Correios
  module CEP
    class Address
      include SAXMachine

      element :end,          as: :street_address
      element :bairro,       as: :neighborhood
      element :cidade,       as: :city
      element :uf,           as: :state
      element :cep,          as: :zipcode
      element :complemento,  as: :complement
      element :complemento2, as: :complement2

      def ==(other)
        instance_variables.each do |attr|
          return false unless self.instance_variable_get(attr) == other.instance_variable_get(attr)
        end

        true
      end

      def has_content?
        [:street_address, :neighborhood, :city, :state, :zipcode].each do |attr|
          return false if self.send(attr).to_s.strip.empty?
        end

        true
      end
    end
  end
end
