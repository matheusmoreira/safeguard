require 'safeguard/command'
require 'safeguard/repository'

module Safeguard
  class Command

    # Adds files to a Repository without hashing them.
    #
    #   $ safeguard add *.mp3
    class Add < Command

      # For every argument, add it to the Repository in the current directory.
      action do |options, files|
        repo = Repository.new options.dir
        repo.before_save do
          repo.add! *files
        end
      end

    end

  end
end
