require 'openssl'

module Safeguard
  module Digest

    def self.file(filename)
      OpenSSL::Digest::SHA1.file(filename).hexdigest
    end

  end
end
