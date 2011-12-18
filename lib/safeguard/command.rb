require 'acclaim/command'

module Safeguard

  # Main Safeguard command. Currently just invokes the init command.
  #
  #   $ safeguard .
  class Command < Acclaim::Command

    opt :dir, '-D', '--dir', '--directory', 'Directory in which the repository is',
              default: Dir.pwd, arity: [1,0]

    action do |options, args|
      Init.execute options, args
    end

  end

end

require 'safeguard/command/add'
require 'safeguard/command/hash'
require 'safeguard/command/init'
require 'safeguard/command/verify'
