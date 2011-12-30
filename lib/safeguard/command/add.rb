require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  class Command

    # Adds files to a Repository.
    class Add < Command

      opt :func, '--hash-function', '--function', '--algorithm',
                 "Algorithm to use to calculate the file's checksum. " <<
                 "Currently supported: #{Digest::SUPPORTED_ALGORITHMS.join(', ')}",
                 default: :sha1, arity: [1,0]

      # For every argument, try to add it to the Repository in the current
      # directory.
      action do |options, args|
        repo = Repository.new options.dir
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
