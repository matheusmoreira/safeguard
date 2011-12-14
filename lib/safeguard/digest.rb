require 'openssl'

module Safeguard

  # Encapsulates checksum computation for files using a set of hash functions.
  module Digest

    # Compute the SHA1 sum of a file.
    def self.file(filename)
      OpenSSL::Digest::SHA1.file(filename).hexdigest
    end

  end
end
