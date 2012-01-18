require 'safeguard/core_ext/file'
require 'safeguard/digest/crc32'
require 'openssl'

module Safeguard

  # Encapsulates checksum computation for files using a set of hash functions.
  module Digest

    algorithms = { sha1:  OpenSSL::Digest::SHA1,
                   md5:   OpenSSL::Digest::MD5,
                   crc32: Safeguard::Digest::CRC32 }.freeze

    SUPPORTED_ALGORITHMS = algorithms.keys.freeze

    # Define one method for every supported algorithm.
    algorithms.each do |algorithm, digest_class|
      define_singleton_method algorithm do |*args|
        digest_with digest_class, *args
      end
    end

    # Digests a file using an +algorithm+.
    #
    # Algorithms are expected include the Digest::Instance module.
    #
    #   OpenSSL::Digest::SHA1.include? Digest::Instance
    #   => true
    def self.digest_with(algorithm, filename)
      digest = algorithm.new
      File.open(filename, 'rb') do |file|
        file.each_chunk do |chunk|
          digest << chunk
        end
      end
      digest.hexdigest!
    end

    private_class_method :digest_with

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
