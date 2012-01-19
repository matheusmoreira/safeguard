require 'i18n'

# Safeguard module.
module Safeguard

  class << self

    # Run a command by name with the given arguments.
    def run(*args)
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

    # Directory where translations are kept.
    def i18n
      File.join root, 'i18n'
    end

    # Array of translation files.
    def translation_files
      Dir[File.join(i18n, '*')]
    end

    def initialize_i18n
      I18n.load_path = translation_files
    end

  end

end

require 'safeguard/command'
require 'safeguard/digest'
require 'safeguard/hasher'
require 'safeguard/repository'
require 'safeguard/verifier'
require 'safeguard/version'
require 'safeguard/worker'
