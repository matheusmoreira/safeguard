require 'safeguard/command'

module Safeguard

  def self.run(command, *args)
    Command.invoke(command, *args)
  end

end
