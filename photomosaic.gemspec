# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'photomosaic/version'

Gem::Specification.new do |spec|
  spec.name          = "photomosaic"
  spec.version       = Photomosaic::VERSION
  spec.authors       = ["Daisuke Fujita"]
  spec.email         = ["dtanshi45@gmail.com"]
  spec.summary       = %q{Photomosaic Generator}
  spec.description   = %q{Photomosaic Generator}
  spec.homepage      = "https://github.com/dtan4/photomosaic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "searchbing"
  spec.add_dependency "rmagick"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "webmock"
end
