# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'czmq-ffi/version'

Gem::Specification.new do |spec|
  spec.name          = 'czmq-ffi'
  spec.version       = LibCZMQ::VERSION
  spec.authors       = ['Mauro Tortonesi']
  spec.email         = ['mauro.tortonesi@unife.it']
  spec.description   = %q{FFI-based Ruby bindings for the CZMQ library}
  spec.summary       = %q{This gem provides low-level bindings for the CZMQ library, using FFI.
    It is not meant to be used directly by applications, but instead to provide
    functions for higher-level gems such as czmq.}
  spec.homepage      = 'https://github.com/mtortonesi/ruby-czmq-ffi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
