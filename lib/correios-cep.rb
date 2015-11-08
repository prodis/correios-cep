require 'ox'
require 'sax-machine'

require 'correios/cep/config'
require 'correios/cep/address'
require 'correios/cep/address_finder'
require 'correios/cep/parser'
require 'correios/cep/web_service'
require 'correios/cep'

SAXMachine.handler = :ox
