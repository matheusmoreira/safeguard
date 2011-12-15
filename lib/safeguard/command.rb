module Safeguard

  # Manages the commands that may be given to Safeguard.
  module Command

    instance_eval do

      # Returns a hash that associates command modules by name.
      def commands
        @commands ||= {}
      end

      alias :all :commands

      # Computes a name for the command and associates it with the command's
      # module.
      def register(command_module)
        name = command_module.name.gsub(/^.*::/, '').downcase
        commands[name] = command_module
      end

      # Looks up a command by name and returns its module, raising an exception
      # if there is no match.
      def find(command_name)
        name = command_name.to_s.strip.downcase
        commands[name].tap do |command|
          raise "unsupported command: #{name}" if command.nil?
        end
      end

      # Attempts to find a command by name, and, if successful, invokes it with
      # the given arguments.
      def invoke(command_name, *args)
        find(command_name).execute(*args)
      end

    end

  end
end

require 'safeguard/command/add'
require 'safeguard/command/hash'
require 'safeguard/command/init'
require 'safeguard/command/verify'
