require 'safeguard/command'

# Safeguard module.
module Safeguard

  # Run a command by name with the given arguments.
  def self.run(command, *args)
    Command.invoke(command, *args)
  end

end
