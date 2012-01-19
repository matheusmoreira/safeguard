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

      # An option will be made for every element in
      # Digest::SUPPORTED_ALGORITHMS. They may be used together and always
      # append to the function array, bound to the <tt>:functions</tt> key.
      #
      # However, due to the lack of a formally defined +functions+ option,
      # the Acclaim option parser will not set that option to anything.
      # Therefore, calling <tt>options.functions</tt> will return an empty
      # ribbon if the user doesn't specify any functions on the command line.
      #
      # <tt>options.functions?</tt> should ALWAYS be called, preferably while
      # providing an empty array as fallback.
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
require 'safeguard/command/add/hash'
require 'safeguard/command/hash'
require 'safeguard/command/init'
require 'safeguard/command/verify'
