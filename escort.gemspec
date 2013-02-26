# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escort/version'

Gem::Specification.new do |gem|
  gem.name          = "escort"
  gem.version       = Escort::VERSION
  gem.authors       = ["Alan Skorkin"]
  gem.email         = ["alan@skorks.com"]
  gem.summary       = %q{A library that makes building command line apps in ruby so easy, you'll feel like an expert is guiding you through it}
  gem.description   = %q{Writing even complex command-line apps should be quick, easy and fun. Escort takes the excellent Trollop option parser and adds a whole bunch of awesome features to produce a library you will always want to turn to when a 'quick script' is in order.}
  gem.homepage      = "https://github.com/skorks/escort"

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('fakefs')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
