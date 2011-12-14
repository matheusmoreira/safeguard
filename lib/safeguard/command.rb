module Safeguard
  module Command

    instance_eval do

      def commands
        @commands ||= {}
      end

      alias :all :commands

      def register(command_module)
        name = command_module.name.gsub(/^.*::/, '').downcase
        commands[name] = command_module
      end

      def find(command_name)
        name = command_name.to_s.strip.downcase
        commands[name].tap do |command|
          raise "unsupported command: #{name}" if command.nil?
        end
      end

      def invoke(command_name, *args)
        find(command_name).execute(*args)
      end

    end

  end
end

require 'safeguard/command/hash'
