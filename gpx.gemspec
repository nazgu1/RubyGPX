# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gpx/version'

Gem::Specification.new do |spec|
  spec.name          = "gpx"
  spec.version       = GPX::VERSION
  spec.authors       = ["Dawid Dziurdzia"]
  spec.email         = ["ddziurdzia@me.com"]
  spec.description   = %q{Provide GPX file parsing}
  spec.summary       = %q{Provide GPX file parsing}
  spec.homepage      = "http://cycloo.pl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  
  spec.add_dependency "nokogiri"
end
