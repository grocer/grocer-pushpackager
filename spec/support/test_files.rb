def test_icon 
  file = Tempfile.new('icon')
  file.write("hello world")
  file.rewind
  file.unlink
  file
end

def test_ssl_pair
  key = OpenSSL::PKey::RSA.new(512)
  name = OpenSSL::X509::Name.parse("CN=auralis/DC=topalis/DC=com")
  cert = OpenSSL::X509::Certificate.new()
  cert.version = 2
  cert.serial = 0
  cert.not_before = Time.new()
  cert.not_after = cert.not_before + (60*60*24*365)
  cert.public_key = key.public_key
  cert.subject = name

  # Sign cert
  cert.issuer = name
  cert.sign(key, OpenSSL::Digest::SHA1.new())

  {certificate: cert, key: key}
end
