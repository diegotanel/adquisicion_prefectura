VCR.configure do |c|
  # c.ignore_hosts "fruta"
  # c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.ignore_localhost = true
end
