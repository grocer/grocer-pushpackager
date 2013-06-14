require 'spec_helper'

describe Grocer::Pushpackager::Package do
  subject {Grocer::Pushpackager::Package}
  it "can be initialized as a valid object" do
    package = subject.new({
      websiteName: "Bay Airlines",
      websitePushID: "web.com.example.domain",
      allowedDomains: ["http://domain.example.com"],
      urlFormatString: "http://domain.example.com/%@/?flight=%@",
      webServiceURL: "https://example.com/push",
      iconSet: { } 
    })
    expect{package.valid?}.to raise_error ArgumentError
    package.authentication_token = "19f8d7a6e9fb8a7f6d9330dabe"
    package.should be_valid
  end

  context "complete, valid package" do
    subject do
      Grocer::Pushpackager::Package.new({
      websiteName: "Bay Airlines",
      websitePushID: "web.com.example.domain",
      allowedDomains: ["http://domain.example.com"],
      urlFormatString: "http://domain.example.com/%@/?flight=%@",
      authenticationToken: "19f8d7a6e9fb8a7f6d9330dabe",
      webServiceURL: "https://example.com/push",
      iconSet: {
        :'16x16' => test_icon,
        :'16x16@2x' => test_icon,
        :'32x32' => test_icon,
        :'32x32@2x' => test_icon,
        :'128x128' => test_icon,
        :'128x128@2x' => test_icon
      }
      })
    end

    it{should be_valid}

    it "generates a non-zero file" do
      subject.send(:build_zip).string.should have_at_least(8).length
    end

    it "writes out file" do
      package = subject.file
      file = File.new('tmp/package.zip', 'w')
      file.write(package.open.read)
      package.unlink
      file.should have_at_least(1).length
      file.close
    end
  end
end
