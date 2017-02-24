# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proximity_beacon/version'

Gem::Specification.new do |spec|
  spec.name          = "proximity_beacon"
  spec.version       = ProximityBeacon::VERSION
  spec.authors       = ["Radius Networks"]
  spec.email         = ["support@radiusnetworks.com"]

  spec.summary       = %q{Allows access to Google's Proximity Beacon API}
  spec.description   = %q{This gem allows you to register beacons, add attachments, etc.}
  spec.homepage      = "https://github.com/RadiusNetworks/proximity_beacon"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
