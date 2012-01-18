# Safeguard module.
module Safeguard

  class << self

    # Run a command by name with the given arguments.
    def run(command, *args)
      Command.invoke(command, *args)
    end

    # Returns the version of Safeguard.
    def version
      Version::STRING
    end

  end

end

require 'safeguard/command'
require 'safeguard/digest'
require 'safeguard/hasher'
require 'safeguard/repository'
require 'safeguard/verifier'
require 'safeguard/version'
