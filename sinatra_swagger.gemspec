# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra_swagger/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra_swagger"
  spec.version       = SinatraSwagger::VERSION
  spec.authors       = ["Tom Krenzke"]
  spec.email         = ["tom.krenzke@hyfn.com"]
  spec.description   = "Generate Swagger api docs by parsing your Sinatra code"
  spec.summary       = "Generate Swagger api docs by parsing your Sinatra code"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['sinswag']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "yard"
  spec.add_dependency "json"
  spec.add_dependency "sinatra"
end
