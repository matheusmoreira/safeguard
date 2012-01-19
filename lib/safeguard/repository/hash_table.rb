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
        ribbon = ribbon.ribbon if self.class === ribbon
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

      # Fetches a value. Same as Hash#fetch.
      def fetch(*args, &block)
        ribbon.fetch *args, &block
      end

      # Looks up the checksum data for the given +filename+.
      def [](filename)
        ribbon.ribbon[filename]
      end

      # Adds a file to the hash table.
      #
      # The file will not have any hash information associated with it.
      def add(*filenames)
        filenames.each { |filename| self[filename] }
      end

      # Same as #add, but returns +self+.
      def <<(filename)
        add filename
        self
      end

      # Returns whether or not the given file is present in this hash table.
      def has_file?(filename)
        ribbon.has_key? filename
      end

      # Returns whether the given file has any hash information associated.
      def has_hashes?(filename, *functions)
        files.include?(filename) and not self[filename].empty?
      end

      # Returns whether the given file has a hash associated with the function
      # stored.
      def has_hash?(filename, function)
        has_hashes?(filename) and self[filename].fetch function, nil
      end

      # Returns a list of files present in this hash table.
      def files
        ribbon.keys
      end

      # The underlying wrapped ribbon used to store filenames and their
      # associated hashes.
      def ribbon
        (@ribbon ||= Ribbon::Wrapper.new).tap do |ribbon|
          # TODO: Possible bottleneck here. #wrap_all! is a recursive call.
          # Keep its usage localized instead of calling it on every access?
          # Once after every modification, perhaps?
          ribbon.wrap_all!
        end
      end

    end

  end
end
