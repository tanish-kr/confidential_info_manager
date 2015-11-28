# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confidential_info_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "confidential_info_manager"
  spec.version       = ConfidentialInfoManager::VERSION
  spec.authors       = ["tatsu07"]
  spec.email         = ["tatsu.tora.1986@gmail.com"]

  spec.summary       = %q{Manage the confidential information}
  spec.description   = %q{It provides the encryption and decryption of data . Also , save the encrypted data in JSON or YAML, you can you read .}
  spec.homepage      = "https://github.com/tatsu07/confidential_info_manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "yaml"
  spec.add_development_dependency "json"
end
