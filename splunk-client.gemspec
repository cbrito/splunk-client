# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors     = ["Christopher Brito"]
  gem.email       = ['cbrito@gmail.com']
  gem.description = %q{splunk-client is a simple Ruby library for interfacing with Splunk's REST API. It supports the retrieving of results via native Ruby methods.}
  gem.summary     = %q{Ruby Library for interfacing with Splunk's REST API}
  gem.homepage    = 'http://github.com/cbrito/splunk-client'
  gem.date        = Date.today

  gem.files       = Dir.glob("{bin,lib,spec}/**/*") + %w(VERSION LICENSE README.md Rakefile Gemfile Gemfile.lock)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "splunk-client"
  gem.require_paths = ["lib"]
  gem.version       = File.read("VERSION").strip
  gem.add_dependency("nokogiri")
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov-rcov"
  gem.add_development_dependency "json"
end
