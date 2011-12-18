require 'acclaim/command'

module Safeguard

  # Main Safeguard command. Currently just invokes the init command.
  #
  #   $ safeguard .
  class Command < Acclaim::Command

    opt :dir, names: %w(-D --dir --directory), default: Dir.pwd, arity: [1,0],
              description: 'Directory in which the repository is'

    action do |options, args|
      Init.execute options, args
    end

  end

end

require 'safeguard/command/add'
require 'safeguard/command/hash'
require 'safeguard/command/init'
require 'safeguard/command/verify'
