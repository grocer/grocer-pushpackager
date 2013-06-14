def test_icon 
  file = Tempfile.new('icon')
  file.write("hello world")
  file.rewind
  file.unlink
  file
end
