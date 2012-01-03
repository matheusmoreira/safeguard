require 'safeguard/hasher'
require 'ribbon'
require 'ribbon/core_ext/array'

module Safeguard

  # Rehashes a set of files and compares the results to the stored hashes.
  class Verifier

    # The hasher used to calculate the checksum of the files.
    attr_accessor :hasher

    # Hash table to compare results against.
    attr_accessor :hash_table

    # Initializes a new verifier with the given files. Last argument can be an
    # options hash or ribbon which specifies the hash table to verify against
    # and the Hasher to use. If a hasher isn't specified, a new one will be
    # created using the files and options given. If no files were given, the
    # hash table's list of files will be used.
    #
    #   files  = %w(file1 file2 file3)
    #   hasher = Hasher.new *files, :functions => :crc32
    #   table  = hasher.results
    #
    #   Verifier.new :hasher => hasher, :hash_table => table
    #   Verifier.new :functions => [ :crc32, :md5 ], :hash_table => table
    #   Verifier.new *files, :functions => :crc32, :hash_table => table
    def initialize(*args)
      ribbon = args.extract_ribbon!
      table = ribbon.hash_table? do
        raise ArgumentError, 'No hash table to verify against'
      end
      self.hash_table = Ribbon[table]
      hash_table.wrap_all!
      args = hash_table.keys if args.empty?
      self.hasher = ribbon.hasher? do
        Hasher.new *args, ribbon
      end
    end

    # Uses the hasher to recalculate the hashes of the files using the specified
    # functions and compares the results with the data on the hash table.
    #
    # If a given file is not present in the hash table, the result of all
    # comparisons will be the <tt>:file_missing</tt> symbol. If the value of a
    # given hash for a given file is not present in the hash table, the result
    # of the comparison will be the <tt>:hash_missing</tt> symbol.
    def verify!
      results = Ribbon.new.tap do |results|
        hasher.each do |file, hash_data|
          hasher.functions.each do |function|
            results[file][function] = if hash_table.has_key? file
              if hash_table[file].has_key? function
                hash_data[function] == hash_table[file][function]
              else
                :hash_missing
              end
            else
              :file_missing
            end
          end
        end
      end
      @results = Ribbon[results]
    end

    # Returns the cached data containing the results of the comparison betweeb
    # the recalculated hashes of the files with the data in the hash table.
    #
    # To force recomputation, call the #verify! method.
    def results
      @results ||= verify!
    end

    # Yields file => comparison data pairs, or returns an enumerator.
    def each(&block)
      Ribbon[results].each &block
    end

    include Enumerable

  end

end