Gem::Specification.new do |s|
  s.name        = 'splunk-client'
  s.version     = '0.5.1'
  s.date        = '2012-04-24'
  s.summary     = "Ruby Library for interfacing with Splunk's REST API"
  s.description = "Simple Ruby library for interfacing with Splunk's REST API."
  s.authors     = ["Christopher Brito"]
  s.email       = 'cbrito@gmail.com'
  s.files       = ["lib/splunk-client.rb"]
  s.homepage    =
    'http://github.com/cbrito/splunk-client'
  s.add_dependency('nokogiri')
end