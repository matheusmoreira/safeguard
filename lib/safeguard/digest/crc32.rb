require 'digest'
require 'zlib'

module Safeguard
  module Digest

    # Digest implementation of CRC32 using Zlib.
    class CRC32 < ::Digest::Class

      include ::Digest::Instance

      INITIAL_VALUE = 0

      attr_reader :crc32

      def initialize
        reset
      end

      def reset
        @crc32 = INITIAL_VALUE
      end

      def update(str)
        @crc32 = Zlib.crc32(str, crc32)
        self
      end

      alias << update

      def finish
        [ crc32 ].pack 'N'
      end

      def digest_length
        1
      end

      def block_length
        1
      end

    end

  end
end
