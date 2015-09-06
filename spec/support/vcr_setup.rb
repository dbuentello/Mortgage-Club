VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_localhost = true
  c.debug_logger = File.open('vcr.log', 'w')
end