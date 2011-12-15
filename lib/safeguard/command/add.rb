require 'safeguard/command'

module Safeguard
  module Command

    # Adds files to the Repository in the current directory.
    module Add

      Command.register self

      # For every argument, add it to the repository.
      def self.execute(*args)
        repo = Repository.new Dir.pwd
        args.each do |filename|
          repo.track filename
        end
      end

    end

  end
end
