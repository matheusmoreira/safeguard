module Safeguard
  module CoreExt
    module File

      # Default size of chunks in bytes. A megabyte is equal to 2^20 bytes, or
      # 1,048,576 bytes.
      DEFAULT_CHUNK_SIZE = 2 ** 20

      # Reads a file piece by piece, yielding every chunk until the end of the
      # file. Will yield chunks of DEFAULT_CHUNK_SIZE bytes, unless specified.
      def each_chunk(chunk_size = DEFAULT_CHUNK_SIZE)
        # A chunk_size of zero will cause an infinite loop. It will keep reading
        # 0 bytes, so the pointer will never change and the end of the file will
        # never be reached.
        bytes = case chunk_size when nil, 0 then nil else chunk_size.abs end
        yield read bytes until eof?
      end

      ::File.include self

    end
  end
end
