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
        args.each do |filename|
          begin
            puts "Adding #{filename}..."
            repo.track filename
          rescue => e
            puts e.message
          end
        end
      end

    end

  end
end
