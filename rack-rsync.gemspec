# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/rsync/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-rsync"
  spec.version       = Rack::Rsync::VERSION
  spec.authors       = ["nownabe"]
  spec.email         = ["nownabe@gmail.com"]

  spec.summary       = %q{A rack middleware to sync files using rsync.}
  spec.homepage      = "https://github.com/nownabe/rack-rsync"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rsync"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
end
