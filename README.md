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
test_icon = File.open('icon.png')
@pair = {
    key: OpenSSL::PKey::RSA.new(File.read('rsa.pem'), 'my pass phrase'),
    certificate: OpenSSL::X509::Certificate.new(File.read('apple-dev.cer'))
}
```

```ruby
builder = Grocer::Pushpackager::Package.new({
    websiteName: "Bay Airlines",
    websitePushID: "web.com.example.domain",
    allowedDomains: ["http://domain.example.com"],
    urlFormatString: "http://domain.example.com/%@/?flight=%@",
    authenticationToken: "19f8d7a6e9fb8a7f6d9330dabe",
    webServiceURL: "https://example.com/push",
    certificate: @pair[:certificate],
    key: @pair[:key],
    iconSet: {
      :'16x16' => test_icon,
      :'16x16@2x' => test_icon,
      :'32x32' => test_icon,
      :'32x32@2x' => test_icon,
      :'128x128' => test_icon,
      :'128x128@2x' => test_icon
    }
})
builder.file # A closed Tempfile that can be read
builder.buffer # A string buffer that can be streamed out to a client
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
