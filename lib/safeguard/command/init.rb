require 'safeguard/command'
require 'safeguard/repository'
require 'fileutils'

module Safeguard
  module Command

    # Initializes a Repository in a given directory.
    module Init

      Command.register self

      # Initializes a Safeguard Repository in a directory, which is either the
      # current directory, if +args+ is empty, or the directory designated by
      # the last element in +args+.
      def self.execute(*args)
        args << Dir.pwd if args.empty?
        dir = File.expand_path args.pop
        repo = Repository.new(dir)
        puts "Initialized safeguard repository in #{repo.dir}"
      end

    end
  end
end
