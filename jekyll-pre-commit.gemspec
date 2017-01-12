# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-pre-commit/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-pre-commit"
  spec.version       = Jekyll::PreCommit::VERSION
  spec.authors       = ["Max Chadwick"]
  spec.email         = ["mpchadwick@gmail.com"]

  spec.summary       = %q{A Jekyll plugin to make sure your post is _really_ ready for publishing}
  spec.homepage      = "https://github.com/mpchadwick/jekyll-pre-commit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 3.3.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
