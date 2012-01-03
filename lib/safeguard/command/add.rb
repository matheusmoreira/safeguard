require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  class Command

    # Adds files to a Repository.
    class Add < Command

      opt :func, '--hash-function', '--hash-functions', Symbol,
                 "Algorithm to use to calculate the file's checksum. " <<
                 "Currently supported: #{Digest::SUPPORTED_ALGORITHMS.join(', ')}",
                 default: :sha1, arity: [1,-1]

      # For every argument, try to add it to the Repository in the current
      # directory.
      action do |options, args|
        repo = Repository.new options.dir
        count = 0
        repo.before_save do
          args.each do |filename|
            begin
              puts "Adding #{filename}..."
              add_checksum_of filename, options.func
              # If an exception is raised, count will not be incremented.
              count += 1
            rescue => e
              puts e.message
            end
          end
        end
        puts "Added #{count} files to repository."
      end

    end

  end
end
