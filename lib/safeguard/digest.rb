require 'openssl'

module Safeguard

  # Encapsulates checksum computation for files using a set of hash functions.
  module Digest

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

    def self.file(filename, hash_function = :sha1)
      send hash_function, filename
    end

  end
end
