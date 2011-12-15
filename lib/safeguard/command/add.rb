require 'safeguard/command'

module Safeguard
  module Command

    # Adds files to a Repository.
    module Add

      Command.register self

      # For every argument, try to add it to the Repository in the current
      # directory.
      def self.execute(*args)
        repo = Repository.new Dir.pwd
        count = 0
        args.each do |filename|
          begin
            puts "Adding #{filename}..."
            repo.track filename
            # If an exception is raised, count will not be incremented.
            count += 1
          rescue => e
            puts e.message
          end
        end
        puts "Added #{count} files to repository."
      end

    end

  end
end
