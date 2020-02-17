# Correios CEP

[![Gem Version](https://badge.fury.io/rb/correios-cep.svg)](http://badge.fury.io/rb/correios-cep)
[![Build Status](https://travis-ci.org/prodis/correios-cep.svg?branch=master)](https://travis-ci.org/prodis/correios-cep)
[![Coverage Status](https://coveralls.io/repos/prodis/correios-cep/badge.svg?branch=master&service=github)](https://coveralls.io/github/prodis/correios-cep?branch=master)
[![Code Climate](https://codeclimate.com/github/prodis/correios-cep/badges/gpa.svg)](https://codeclimate.com/github/prodis/correios-cep)
[![GitHub license](https://img.shields.io/apm/l/vim-mode.svg)](LICENSE)

![Correios Logo](http://prodis.net.br/images/ruby/2015/correios_logo.png)

Current available solutions to find Brazilian addresses by zipcode use an HTML form from [Correios web site](http://correios.com.br) website to perform it, instead of to use a real API.

The old solution works with an HTTP request to the form, followed by parsing HTML result page. The huge problem here is when the Correios web site development team decides to modify some HTML element in the result page, even a layout update, it will break the parser logic for result.

Correios CEP gem solves this problem, retrieving data directly from Correios database.

## Installing

### Gemfile

```ruby
gem 'correios-cep'
```

### Direct installation

```console
$ gem install correios-cep
```


## Using

```ruby
require 'correios-cep'

# With "get" instance method
finder = Correios::CEP::AddressFinder.new
address = finder.get('54250610')

# With "get" class method
address = Correios::CEP::AddressFinder.get('54250610')

address # =>
{
  :address => 'Rua Fernando Amorim',
  :neighborhood => 'Cavaleiro',
  :city => 'Jaboatão dos Guararapes',
  :state => 'PE',
  :zipcode => '54250610',
  :complement => ''
}
```


## Configurations

All the configurations are set using `Correios::CEP` module.

### Timeout

For default, the timeout for a request to Correios Web Service is **5 seconds**. If Correios Web Service does not respond, a `HTTP::TimeoutError` exception will be raised.

```ruby
Correios::CEP.configure do |config|
  config.request_timeout = 3 # It configures timeout to 3 seconds
end
```

### HTTP Proxy
If you need to use an HTTP proxy to HTTP requests, configure HTTP proxy URL.

```ruby
Correios::CEP.configure do |config|
  config.proxy_url = 'http://10.20.30.40:8888'
end
```

### Log

From `0.7.0` version, there is no more default logger, and the log level will be the same of the given logger.

```ruby
Correios::CEP.configure do |config|
  config.logger = Rails.logger
end
```

### Configuration example

```ruby
Correios::CEP.configure do |config|
  config.logger = Rails.logger
  config.request_timeout = 3 # seconds
end
```

## Credits

### Author
[Fernando Hamasaki de Amorim (prodis)](https://github.com/prodis)

![Prodis Logo](https://camo.githubusercontent.com/c01a3ebca1c000d7586a998bb07316c8cb784ce5/687474703a2f2f70726f6469732e6e65742e62722f696d616765732f70726f6469735f3135302e676966)

### Contributors
https://github.com/prodis/correios-cep/graphs/contributors

## Contributing

See the [contributing guide](https://github.com/prodis/correios-cep/blob/master/CONTRIBUTING.md).


## License

Correios CEP gem is released under the Apache 2.0 License. See the [LICENSE](https://github.com/prodis/correios-cep/blob/master/LICENSE) file.
