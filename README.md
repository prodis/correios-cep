# Correios CEP

Current available solutions to find Brazilian addresses by zipcode use an HTML form from Correios web site to perform it, instead of to use a real API.

The old solution works with an HTTP request to the form, followed by parsing the HTML result page. The huge problem here is when the Correios web site development team decides to modify some HTML element in the result page, even a layout update, it will break the parser logic for result.

Correios CEP gem solves this problem, getting data directly from Correios database.

![Correios Logo](http://prodis.net.br/images/ruby/2011/correios_logo.png)

[![Gem Version](https://badge.fury.io/rb/correios-cep.png)](http://badge.fury.io/rb/correios-cep)
[![Build Status](https://travis-ci.org/prodis/correios-cep.png?branch=master)](https://travis-ci.org/prodis/correios-cep)
[![Coverage Status](https://coveralls.io/repos/prodis/correios-cep/badge.png)](https://coveralls.io/r/prodis/correios-cep)
[![Code Climate](https://codeclimate.com/github/prodis/correios-cep.png)](https://codeclimate.com/github/prodis/correios-cep)
[![Dependency Status](https://gemnasium.com/prodis/correios-cep.png)](https://gemnasium.com/prodis/correios-cep)

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
  address = finder.get("54250610")

  # With "get" class method
  address = Correios::CEP::AddressFinder.get("54250610")

  address # =>
  {
    :address => "Rua Fernando Amorim",
    :neighborhood => "Cavaleiro",
    :city => "Jaboatão dos Guararapes",
    :state => "PE",
    :zipcode => "54250610",
    :complement => ""
  }
```

## Configurations

### Timeout

For default, the timeout for a request to Correios Web Service is **5 seconds**. If Correios Web Service does not respond, a `Timeout::Error` exception will be raised.
You can configure this timeout using `Correios::CEP` module.

```ruby
  Correios::CEP.configure do |config|
    config.request_timeout = 3 # It configures timeout to 3 seconds
  end
```

### HTTP Proxy
If you need to use an HTTP proxy to HTTP requests, configure the HTTP proxy URL on `Correios::CEP` module.

```ruby
  Correios::CEP.configure do |config|
    config.proxy_url = "http://10.20.30.40:8888"
  end
```

### Log

For default, each request to Correios Web service is logged to STDOUT, with **:info** log level, using the gem [LogMe](http://github.com/prodis/log-me).

Log example:

```xml
  I, [2014-02-14T00:10:12.718413 #76361]  INFO -- : [Correios::CEP] Request:
  POST http://200.252.60.209/SigepCliente/AtendeClienteService
  <?xml version="1.0" encoding="UTF-8"?>
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
    <soapenv:Header />
    <soapenv:Body>
      <cli:consultaCEP>
        <cep>54250610</cep>
      </cli:consultaCEP>
    </soapenv:Body>
  </soapenv:Envelope>

  I, [2014-02-14T00:10:12.969937 #76361]  INFO -- : [Correios::CEP] Response:
  HTTP/1.1 200 OK
  <?xml version='1.0' encoding='UTF-8'?>
  <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
    <S:Body>
      <ns2:consultaCEPResponse xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">
        <return>
          <bairro>Cavaleiro</bairro>
          <cep>54250610</cep>
          <cidade>Jaboatão dos Guararapes</cidade>
          <complemento></complemento>
          <complemento2></complemento2>
          <end>Rua Fernando Amorim</end>
          <id>0</id>
          <uf>PE</uf>
        </return>
      </ns2:consultaCEPResponse>
    </S:Body>
  </S:Envelope>
```

To disable the log and configure other log output, use **Correios::CEP** module:

```ruby
  Correios::CEP.configure do |config|
    config.log_enabled = false   # It disables the log
    config.logger = Rails.logger # It uses Rails logger
  end
```  

### Configuration example

```ruby
  Correios::CEP.configure do |config|
    config.logger = Rails.logger
    config.request_timeout = 3
  end
```

## Changelog

[See the changes in each version.](CHANGELOG.md)


## Author
- [Fernando Hamasaki de Amorim (prodis)](http://prodis.blog.br)

![Prodis Logo](http://prodis.net.br/images/prodis_150.gif)


## Contributing to correios-cep

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Don't forget to rebase with branch master in main project before submit the pull request.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
