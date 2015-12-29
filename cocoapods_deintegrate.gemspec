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

  spec.files         = Dir['lib/**/*.rb'] + %w( README.md LICENSE )
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'
end
