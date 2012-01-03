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
        Ribbon.merge! table, ribbon, &block if ribbon
      end

      # Saves the HashTable to a YAML file.
      def save(filename)
        File.open(filename, 'w') do |file|
          file.puts table.to_yaml
        end
      end

      # Loads the HashTable from a YAML file.
      def self.load(filename)
        new YAML::load_file(filename).to_ribbon
      end

      # Looks up the checksum data for the given +filename+.
      def [](filename)
        table[filename]
      end

      protected

      def table
        @table ||= Ribbon::Wrapper.new
      end

    end

  end
end
