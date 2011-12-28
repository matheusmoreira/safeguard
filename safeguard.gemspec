#!/usr/bin/env gem build
# encoding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)

require 'safeguard/version'

Gem::Specification.new('safeguard') do |gem|

  gem.version     = Safeguard::Version::STRING
  gem.summary     = 'File integrity verification utility'
  gem.description = 'Hash-based file integrity verification utility'
  gem.homepage    = 'https://github.com/matheusmoreira/safeguard'

  gem.author = 'Matheus Afonso Martins Moreira'
  gem.email  = 'matheus.a.m.moreira@gmail.com'

  gem.files       = `git ls-files`.split "\n"
  gem.executables = `git ls-files -- bin/*`.split("\n").map &File.method(:basename)

  gem.add_runtime_dependency 'acclaim'
  gem.add_runtime_dependency 'ribbon'

  gem.add_development_dependency 'rookie'

end
