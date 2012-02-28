# Safeguard module.
module Safeguard

  class << self

    # Run a command by name with the given arguments.
    def run(*args)
      initialize_i18n
      Command.run *args
    end

    # Returns the version of Safeguard.
    def version
      Version::STRING
    end

    # Where the Safeguard installation is located.
    def root
      File.expand_path '../..', __FILE__
    end

    # Where the binary files are located.
    def bin
      File.join root, 'bin'
    end

    # Where the source code is located.
    def lib
      File.join root, 'lib'
    end

    # Directory where translations are kept.
    def i18n
      File.join root, 'i18n'
    end

    # Array of translation files.
    def translation_files
      Dir[File.join(i18n, '*')]
    end

    private

    # The <tt>safeguard.gemspec</tt> file.
    def gemspec_file
      File.join root, '.gemspec'.prepend(name.downcase)
    end

    # Safeguard's Gem::Specification.
    def gemspec
      Gem::Specification.load gemspec_file
    end

    # Loads all available translations.
    def initialize_i18n
      require 'i18n'
      I18n.load_path = translation_files
    end

    # Ensure the correct versions of all gems specified as dependencies in the
    # gem specification are loaded.
    def ensure_correct_versions
      gemspec.dependencies.each do |dependency|
        gem dependency.name, dependency.requirement if dependency.type == :runtime
      end
    end

    # Safeguard's modules.
    def modules
      Dir[File.join lib, name.downcase, '*'].select do |file|
        File.file? file
      end.map do |file|
        File.basename file, '.rb'
      end
    end

    # Requires all Safeguard modules.
    def require_modules
      modules.each do |mod|
        require "#{name.downcase}/#{mod}"
      end
    end

  end

end

require 'safeguard/command'
require 'safeguard/digest'
require 'safeguard/hasher'
require 'safeguard/output'
require 'safeguard/repository'
require 'safeguard/verifier'
require 'safeguard/version'
require 'safeguard/worker'
