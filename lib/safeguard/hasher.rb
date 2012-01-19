require 'safeguard/digest'
require 'safeguard/worker'
require 'ribbon'
require 'ribbon/core_ext/array'

module Safeguard

  # Hashes a set of files.
  class Hasher < Worker

    # The files which will be hashed.
    attr_accessor :files

    # The hash functions to use.
    attr_accessor :functions

    # Available callbacks.
    has_callbacks :before_hashing, :after_hashing

    # Initializes a new hasher with the given files. Last argument can be an
    # options hash or ribbon which specifies the hash functions to use:
    #
    #   files = %w(file1 file2 fil3)
    #   Hasher.new *files, :functions => :sha1
    #   Hasher.new *files, :functions => [ :sha1, :md5, :crc32 ]
    def initialize(*args)
      options = args.extract_ribbon!
      funcs = options.functions? do
        raise ArgumentError, 'No hash functions specified'
      end
      self.functions = [*funcs]
      self.files = args
      initialize_callbacks_from options
    end

    # Calculates the hash of each file. Updates the cached hash results.
    def hash_files!
      results = Ribbon.new
      files.each do |file|
        functions.each do |function|
          call_callback before_hashing, file, function
          results[file][function] = result = Safeguard::Digest.file file, function
          call_callback after_hashing, file, function, result
        end
      end
      results = Ribbon[results]
      results.wrap_all!
      @results = results
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
