# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods_deintegrate.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-deintegrate'
  spec.version       = CocoapodsDeintegrate::VERSION
  spec.authors       = ['Kyle Fuller']
  spec.email         = ['inbox@kylefuller.co.uk']
  spec.summary       = 'A CocoaPods plugin to remove and de-intergrate CocoaPods from your project.'
  spec.homepage      = 'https://github.com/kylef/cocoapods-deintergrate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'cocoapods'
end

