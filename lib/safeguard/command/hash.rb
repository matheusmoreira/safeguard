require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  class Command

    # Outputs the checksum of files.
    #
    #   $ safeguard hash *.mp3
    #
    # The hash function can be specified with the --hash-function option. The
    # default is SHA1, but MD5 and CRC32 are also supported.
    #
    #   $ safeguard --hash-function md5 hash *.mp3
    class Hash < Command

      opt :func, '--function', '--hash-function', '--algorithm',
                 "Algorithm to use to calculate the file's checksum. " <<
                 "Currently supported: #{Digest::SUPPORTED_ALGORITHMS.join(', ')}",
                 default: :sha1, arity: [1,-1]

      # For every argument, outputs its checksum if it exists as a file.
      action do |options, args|
        args.each do |filename|
          next unless File.readable? filename
          digest = Digest.file filename, options.func
          puts "#{digest} => #{filename}"
        end
      end

    end

  end
end
