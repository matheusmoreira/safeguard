require 'safeguard/digest'
require 'ribbon'
require 'ribbon/core_ext'
require 'yaml'

module Safeguard
  class Repository

    # Holds filename => checksum pairs.
    class HashTable

      # Initializes this hash table with the contents of the given Ribbon.
      def initialize(ribbon = nil)
        Ribbon.merge! table, ribbon if ribbon
      end

      # Saves the HashTable to a YAML file.
      def save(filename)
        File.open(filename, 'w') do |file|
          file.puts Ribbon[table].to_yaml
        end
      end

      # Loads the HashTable from a YAML file.
      def self.load(filename)
        new YAML::load_file(filename).to_ribbon
      end

      # Associates the given +filename+ to the computed checksum of the file it
      # refers to.
      def add(filename, hash_function)
        digest = Digest.file filename, hash_function
        table[filename][hash_function] = digest
      end

      # Looks up the checksum data for the given +filename+.
      def [](filename)
        table[filename]
      end

      # Recalculates the hash and compares it to the original hash associated
      # with the given filename.
      #
      # If a hash for the given file isn't stored in this table, an exception
      # will be raised.
      def verify(filename)
        hash = table[filename]
        raise "File not in repository: #{filename}" unless hash
        Digest.file(filename) == hash
      end

      # Verifies all files stored in this table and returns a hash of results
      # associating a filename with either +true+, when the file's recalculated
      # hash is equal to the hash stored in this table, or +false+, when
      # otherwise.
      #
      # The filename and the result will be yielded if given a block.
      def verify_all
        {}.tap do |results|
          Ribbon[table].keys.each do |file|
            results[file] = result = verify file
            yield file, result if block_given?
          end
        end
      end

      protected

      def table
        @table ||= Ribbon.new
      end

    end

  end
end
