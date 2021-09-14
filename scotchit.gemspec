# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scotchit/version'

Gem::Specification.new do |spec|
  spec.name          = "scotchit"
  spec.version       = Scotchit::VERSION
  spec.authors       = ["Robert Hardin"]
  spec.email         = ["rob@roberthardin.net"]
  spec.summary       = %q{A scotch recommendation engine based on reddit.com/r/scotch's review archive.}
  spec.description   = %q{Runs a lower bound confidence score on scotchit's whisky review archive to generate buy recommendations.}
  spec.homepage      = "https://github.com/rhardin/scotchit"
  spec.license       = "GPL-2.0-or-later"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.10"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "statistics2", "~> 0.54"
end
