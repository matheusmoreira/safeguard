require 'openssl'
require 'zlib'

module Safeguard

  # Encapsulates checksum computation for files using a set of hash functions.
  module Digest

    SUPPORTED_ALGORITHMS = %w(sha1 md5 crc32).map!(&:to_sym).freeze

    # Digests a file using an +algorithm+.
    #
    # Algorithms are expected include the Digest::Instance module.
    #
    #   OpenSSL::Digest::SHA1.include? Digest::Instance
    #   => true
    def self.digest_file(filename, algorithm)
      algorithm.file(filename).hexdigest
    end

    private_class_method :digest_file

    # Compute the SHA1 sum of a file.
    def self.sha1(filename)
      digest_file filename, OpenSSL::Digest::SHA1
    end

    # Compute the MD5 sum of a file.
    def self.md5(filename)
      digest_file filename, OpenSSL::Digest::MD5
    end

    # Compute the CRC32 sum of a file.
    def self.crc32(filename)
      # Read file in binary mode. Doesn't make any difference in *nix, but Ruby
      # will attempt to convert line endings if the file is opened in text mode
      # in other platforms.
      data = File.binread filename
      Zlib.crc32(data).to_s 16
    end

    # Digests a file using a hash function, which can be the symbol of any
    # Digest module method that takes a filename. Uses SHA1 by default.
    #
    #   Safeguard::Digest.file(filename, :md5)
    #
    # Is equivalent to:
    #
    #   Safeguard::Digest.md5(filename)
    def self.file(filename, hash_function = :sha1)
      send hash_function, filename
    end

  end
end
