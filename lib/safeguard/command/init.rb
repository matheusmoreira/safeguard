require 'safeguard/command'
require 'safeguard/repository'
require 'fileutils'

module Safeguard
  module Command
    module Init

      Command.register self

      def self.execute(*args)
        args << Dir.pwd if args.empty?
        dir = File.expand_path args.pop
        repo = Repository.new(dir)
        puts "Initialized safeguard repository in #{repo.dir}"
      end

    end
  end
end
