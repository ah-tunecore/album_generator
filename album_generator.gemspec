# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'album_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "album_generator"
  spec.version       = AlbumGenerator::VERSION
  spec.authors       = ["Andrew Hoglund"]
  spec.email         = ["ahoglund@tunecore.com"]

  spec.summary       = %q{Generate random album title, artist, and artwork.}
  spec.description   = %q{The logic for this gem is based on the rules from: http://www.noiseaddicts.com/2009/03/random-band-name-cover-album/}
  spec.homepage      = "http://github.com/ah-tunecore"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = %w{album_generator}
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
