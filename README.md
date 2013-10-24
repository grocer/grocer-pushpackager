# Grocer::Pushpackager
[![Build Status](https://secure.travis-ci.org/grocer/grocer-pushpackager.png)](http://travis-ci.org/grocer/grocer-pushpackager)
[![Gem Version](https://badge.fury.io/rb/grocer-pushpackager.png)](http://badge.fury.io/rb/grocer-pushpackager)
[![Code Climate](https://codeclimate.com/github/grocer/grocer-pushpackager.png)](https://codeclimate.com/github/grocer/grocer-pushpackager)
[![Coverage Status](https://coveralls.io/repos/grocer/grocer-pushpackager/badge.png?branch=master)](https://coveralls.io/r/grocer/grocer-pushpackager)
[Documentation](http://rubydoc.info/gems/grocer-pushpackager/)

Builds a PushPackage for Apple's APN for use with Safari/Mavericks
## Installation

Add this line to your application's Gemfile:

    gem 'grocer-pushpackager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grocer-pushpackager

## Usage

```ruby
p12 = OpenSSL::PKCS12.new(File.read('certificate.p12'), 'PASSWORD')

builder = Grocer::Pushpackager::Package.new({
    websiteName: "Bay Airlines",
    websitePushID: "web.com.example.domain",
    allowedDomains: ["http://domain.example.com"],
    urlFormatString: "http://domain.example.com/%@/?flight=%@",
    authenticationToken: "19f8d7a6e9fb8a7f6d9330dabe",
    webServiceURL: "https://example.com/push",
    certificate: p12.certificate,
    key: p12.key,
    iconSet: {
      :'16x16' => File.open('icon.png'),
      :'16x16@2x' => File.open('icon.png'),
      :'32x32' => File.open('icon.png'),
      :'32x32@2x' => File.open('icon.png'),
      :'128x128' => File.open('icon.png'),
      :'128x128@2x' => File.open('icon.png')
    }
})
builder.file # A closed Tempfile that can be read
builder.buffer # A string buffer that can be streamed out to a client
```

## Obtaining a Certificate

1. Visit the [Website Push IDs](https://developer.apple.com/account/ios/identifiers/websitePushId/websitePushIdList.action) page under Identifiers in the Developer Center.
2. Create a new ID.
3. Download the new certificate in the Certificates section.
4. Open the certificate in Keychain Access
5. Right click on the certificate and choose export. Select the p12 option.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
