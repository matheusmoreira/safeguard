require 'safeguard/digest'
require 'ribbon'
require 'ribbon/core_ext'
require 'yaml'

module Safeguard
  class Repository

    # Holds filename => checksum pairs.
    class HashTable

      # Initializes this hash table with the contents of the given Ribbon.
      def initialize(ribbon = nil, &block)
        merge! ribbon, &block if ribbon
      end

      # Saves the HashTable to a YAML file.
      def save(filename)
        File.open(filename, 'w') do |file|
          file.puts ribbon.to_yaml
        end
      end

      # Loads the HashTable from a YAML file.
      def self.load(filename)
        new Ribbon::Wrapper.from_yaml File.read(filename)
      end

      # Merges this hash table's data with the other's.
      def merge!(other, &block)
        ribbon.deep_merge! other, &block
      end

      # Looks up the checksum data for the given +filename+.
      def [](filename)
        ribbon.ribbon[filename]
      end

      # Adds a file to the hash table.
      #
      # The file will not have any hash information associated with it.
      def add(filename)
        self[filename]
      end

      # Returns a list of files present in this hash table.
      def files
        ribbon.keys
      end

      # The underlying wrapped ribbon used to store filenames and their
      # associated hashes.
      def ribbon
        @ribbon ||= Ribbon::Wrapper.new
      end

    end

  end
end
