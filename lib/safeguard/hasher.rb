require 'safeguard/digest'
require 'ribbon'
require 'ribbon/core_ext/array'

module Safeguard

  # Hashes a set of files.
  class Hasher

    # The files which will be hashed.
    attr_accessor :files

    # The hash functions to use.
    attr_accessor :functions

    # Initializes a new hasher with the given files. Last argument can be an
    # options hash or ribbon which specifies the hash functions to use:
    #
    #   files = %w(file1 file2 fil3)
    #   Hasher.new *files, :functions => :sha1
    #   Hasher.new *files, :functions => [ :sha1, :md5, :crc32 ]
    def initialize(*args)
      ribbon = args.extract_options_as_ribbon!
      funcs = ribbon.functions? do
        raise ArgumentError, 'No hash functions specified'
      end
      self.functions = [*funcs]
      self.files = args
    end

    # Calculates the hash of each file. Updates the cached hash results.
    def hash_files!
      results = Ribbon.new.tap do |results|
        files.each do |file|
          functions.each do |function|
            results[file][function] = Safeguard::Digest.file file, function
          end
        end
      end
      @results = Ribbon[results]
    end

    # Returns the cached results containing the hashes calculated for each file.
    #
    # In order to force hash recalculation, call #hash_files!.
    def results
      @results ||= hash_files!
    end

    # Yields file => hash data pairs or returns an enumerator.
    def each(&block)
      Ribbon[results].each &block
    end

    include Enumerable

  end

end
