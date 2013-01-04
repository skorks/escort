# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escort/version'

Gem::Specification.new do |gem|
  gem.name          = "escort"
  gem.version       = Escort::VERSION
  gem.authors       = ["Alan Skorkin"]
  gem.email         = ["alan@skorks.com"]
  gem.summary       = %q{An escort is still a trollop just dressed up}
  gem.description   = %q{Basically we take the excellent Trollop command line options parser and dress it up a little with some DSL to make writing CLI apps a bit nicer, but still retain the full power of the awesome Trollop.}
  gem.homepage      = "https://github.com/skorks/escort"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
