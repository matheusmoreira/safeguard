require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  class Command

    # Outputs the SHA1 hash of files.
    class Hash < Command

      # For every argument, outputs its SHA1 sum if it exists as a file.
      action do |options, args|
        args.each do |filename|
          puts "#{Digest.file filename} => #{filename}" if File.file? filename
        end
      end

    end

  end
end
