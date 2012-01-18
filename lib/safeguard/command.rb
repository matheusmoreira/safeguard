require 'safeguard/digest'
require 'safeguard/version'
require 'acclaim/command'

module Safeguard

  # Main Safeguard command. Currently just invokes the init command.
  #
  #   $ safeguard .
  class Command < Acclaim::Command

    help
    version Safeguard::Version::STRING

    opt :dir, '-D', '--directory', 'Directory in which the repository is.',
              default: Dir.pwd, arity: [1,0]

    action do |options, args|
      Init.execute options, args
    end

    # The class methods.
    class << self

      def add_supported_algorithms_as_options!
        Digest::SUPPORTED_ALGORITHMS.each do |algorithm|
          option algorithm, "Use #{algorithm.to_s.upcase}." do |options|
            options.functions = (options.functions? []) << algorithm
          end
        end
      end

    end

  end

end

require 'safeguard/command/add'
require 'safeguard/command/hash'
require 'safeguard/command/init'
require 'safeguard/command/verify'
