# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.8.0] - 2020-02-17
### Changed
- Update Ox gem version to `2.13`.
- Update HTTP gem version to `4.3`.
- Minimal required Ruby version now is 2.3.0.

## [0.7.1] - 2018-11-19
### Fixed
- Fix uninitialised constant error [Issue #23](https://github.com/prodis/correios-cep/issues/23)

## [0.7.0] - 2018-11-18
### Changed
- Replace Net::HTTP to HTTP gem. [Issue #15](https://github.com/prodis/correios-cep/issues/15)
- Minimal required Ruby version now is 2.2.0.

### Removed
- Remove `log-me` gem.

## [0.6.8] - 2018-11-01
### Fixed
- Fix parsing bug when Correios API omits "complemento" XML node in response.

## [0.6.7] - 2018-03-19
### Changed
- Update Ox gem version to `2.9`.

## [0.6.6] - 2018-03-13
### Changed
- Update Ox gem version to `2.8.4`.

## [0.6.5] - 2017-12-04
### Changed
- Update Ox gem version to `2.8.2`. [PR #17](https://github.com/prodis/correios-cep/pull/17)

## [0.6.4] - 2017-04-23
### Changed
- Update Ox gem version to `2.4.13`.

## [0.6.3] - 2017-03-19
### Changed
- Improve performance regarding strings.

## [0.6.2] - 2017-03-18
### Changed
- Update Ox gem version to `2.4`. [PR #14](https://github.com/prodis/correios-cep/pull/14)

## [0.6.1] - 2015-12-17
### Changed
- Update LogMe gem version to `0.0.10`.

## [0.6.0] - 2015-11-10
### Changed
- Minimal required Ruby version now is 2.0.0.

## [0.5.1] - 2015-11-03
### Changed
- Zipcode input validation improvement.

## [0.5.0] - 2015-10-30
### Added
- Zipcode input validation.

### Fixed
- Handle errors returned from Correios web service. [Issue #10](https://github.com/prodis/correios-cep/issues/10)

## [0.4.0] - 2015-04-29
### Changed
- Replace Nokogiri by Ox. [Issue #3](https://github.com/prodis/correios-cep/issues/3)

## [0.3.3] - 2015-04-24
### Changed
- Downgrade LogMe gem version to `0.0.8`, because `0.0.9` does not support Ruby 1.9.2.

## [0.3.2] - 2015-04-24
### Added
- Optional use of HTTP proxy.

### Changed
- Update LogMe gem version to `0.0.9`.

## [0.3.1] - 2015-03-24
### Changed
- Minimal required Ruby version now is 1.9.2 again.

## [0.3.0] - 2015-03-20
### Changed
- Update Correios web service URL.

## [0.2.0] - 2014-11-14
### Changed
- Minimal required Ruby version now is 1.9.3.

## [0.1.4] - 2014-06-27
### Changed
- Minimal required Ruby version now is 1.9.2.

## [0.1.3] - 2014-02-21
### Changed
- Update LogMe gem to version `0.0.6` with support to log request and response messages.

## [0.1.2] - 2014-02-19
### Changed
- Update LogMe gem to version `0.0.5` with support to log messages label.

## [0.1.1] - 2014-02-14
### Added
- `AddressFinder.get` class method.

## [0.1.0] - 2014-02-14
### Added
- First working version.

## [0.0.1] - 2014-02-12
### Added
- First version, not working yet.
