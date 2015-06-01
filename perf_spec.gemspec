# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perf_spec/version'

Gem::Specification.new do |spec|
  spec.name          = 'perf_spec'
  spec.version       = PerfSpec::VERSION
  spec.authors       = ['Pawel Niemczyk']
  spec.email         = ['pniemczyk@o2.pl']

  spec.summary       = 'Add ability to test performance of request in Rspec tests'
  spec.description   = 'Add ability to test performance of request in Rspec tests'
  spec.homepage      = 'https://github.com/pniemczyk/perf_spec'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_runtime_dependency 'meta_request', '~> 0.3'
  spec.add_runtime_dependency 'awesome_print', '~> 1.6'
end
