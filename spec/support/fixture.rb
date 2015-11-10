module Fixture
  class << self
    def load(name)
      case name
      when :address,
           :address_with_complement,
           :address_with_two_complements,
           :address_not_found
        read_file_for(name)
      else
        raise ArgumentError, "Fixture '#{name}' not found."
      end
    end

    def read_file_for(filename)
      File.open("#{File.expand_path("../../", __FILE__)}/fixtures/#{filename}.xml").read
    end
  end
end
