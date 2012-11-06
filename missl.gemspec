# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'missl/version'

Gem::Specification.new do |gem|
  gem.name          = "missl"
  gem.version       = Missl::VERSION
  gem.authors       = ["Blake Beaupain"]
  gem.email         = ["blake@vexsoftware.com"]
  gem.description   = %q{A simple image proxy based on Sinatra. Performs basic filtering to limit content type to images, and content length to 5MB. Local IP addresses are also restricted.}
  gem.summary       = %q{A simple image proxy based on Sinatra.}
  gem.homepage      = "http://vexsoftware.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra"
end
