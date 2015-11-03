# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods/deintegrate/gem_version'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-deintegrate'
  spec.version       = CocoapodsDeintegrate::VERSION
  spec.authors       = ['Kyle Fuller']
  spec.email         = ['kyle@fuller.li']
  spec.summary       = 'A CocoaPods plugin to remove and de-integrate CocoaPods from your project.'
  spec.homepage      = 'https://github.com/kylef/cocoapods-deintegrate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'cocoapods', '~> 0.34'
end
