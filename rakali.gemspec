# -*- encoding: utf-8 -*-
require File.expand_path("../lib/rakali/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rakali'
  s.version     = Rakali::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Fenner"]
  s.email       = 'mf@martinfenner.org'
  s.homepage    = 'https://github.com/rakali/rakali.rb'
  s.summary     = 'A Pandoc command-line wrapper'
  s.description = 'A Pandoc command-line wrapper written in Ruby.'
  s.license     = 'MIT'

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'thor', '~> 0.19'
  s.add_dependency 'json-schema', '~> 2.2'
  s.add_dependency 'safe_yaml', "~> 1.0"
  s.add_dependency 'colorator', "~> 0.1"
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency "rspec", '~> 2.6'
  s.add_development_dependency "cucumber", '~> 1.3'
  s.add_development_dependency "aruba", '~> 0'

  s.files       = Dir.glob("lib/**/*.rb")
  s.executables = ["rakali"]
end
