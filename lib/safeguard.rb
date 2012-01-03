require 'safeguard/command'
require 'safeguard/digest'
require 'safeguard/hasher'
require 'safeguard/repository'
require 'safeguard/verifier'
require 'safeguard/version'

# Safeguard module.
module Safeguard

  # Run a command by name with the given arguments.
  def self.run(command, *args)
    Command.invoke(command, *args)
  end

end
