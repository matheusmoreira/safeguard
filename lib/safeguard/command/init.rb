require 'safeguard/command'
require 'safeguard/output/terminal'
require 'safeguard/repository'

module Safeguard
  class Command

    # Initializes a Repository in a given directory.
    #
    #   $ safeguard init
    class Init < Command

      # Initializes a Safeguard Repository in a directory, which is either the
      # current directory, if +args+ is empty, or the directory designated by
      # the last element in +args+.
      action do |options, args|
        dir = File.expand_path(args.pop || options.dir)
        repo = Repository.new(dir)
        repo.create_directory!
        Output::Terminal.initialized_repository repo.dir
      end

    end

  end
end
