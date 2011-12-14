require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  module Command

    # Outputs the SHA1 hash of files.
    module Hash

      Command.register self

      # For every argument, outputs its SHA1 sum if it exists as a file.
      def self.execute(*args)
        args.each do |filename|
          puts "#{Digest.file filename} => #{filename}" if File.file? filename
        end
      end

    end
  end
end
