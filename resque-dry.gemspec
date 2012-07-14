# -*- encoding: utf-8 -*-
require File.expand_path '../lib/resque-dry/version', __FILE__

Gem::Specification.new do |gem|
  gem.authors       = ['Sijawusz Pur Rahnama']
  gem.email         = ['sija@sija.pl']
  gem.summary       = ''
  gem.homepage      = 'https://github.com/Sija/resque-dry'
  gem.description   = %q(
  )

  gem.files         = `git ls-files`.split $\
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename f }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'resque-dry'
  gem.require_paths = ['lib']
  gem.version       = Resque::Plugins::DRY::VERSION
  
  gem.add_dependency 'resque', '>= 1.20.0'
end
