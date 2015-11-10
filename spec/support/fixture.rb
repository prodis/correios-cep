module Fixture
  def self.load(name)
    File.open("#{File.expand_path('../../', __FILE__)}/fixtures/#{name}.xml").read
  end
end
