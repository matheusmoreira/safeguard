require 'safeguard/core_ext/file'
require 'safeguard/digest/crc32'
require 'openssl'

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
    def self.digest_with(algorithm, file)
      algorithm.file(file).hexdigest
    end

    private_class_method :digest_with

    # Computes the SHA1 sum of the given file.
    def self.sha1(*args)
      digest_with OpenSSL::Digest::SHA1, *args
    end

    # Computes the MD5 sum of the given file.
    def self.md5(*args)
      digest_with OpenSSL::Digest::MD5, *args
    end

    # Computes the CRC32 sum of the given file.
    def self.crc32(*args)
      # Read file in binary mode. Doesn't make any difference in *nix, but Ruby
      # will attempt to convert line endings if the file is opened in text mode
      # in other platforms.
      digest_with Safeguard::Digest::CRC32, *args
    end

    # Digests a file using a hash function, which can be the symbol of any
    # Digest module method that takes a file. Uses SHA1 by default.
    #
    #   Safeguard::Digest.file(file, :md5)
    #
    # Is equivalent to:
    #
    #   Safeguard::Digest.md5(file)
    def self.file(file, hash_function = :sha1)
      f = hash_function.to_sym
      raise ArgumentError, "Unsupported hash function: #{f}" unless respond_to? f
      send hash_function, file
    end

  end
end
