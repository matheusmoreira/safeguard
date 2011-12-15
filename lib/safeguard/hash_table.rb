require 'safeguard/digest'
require 'yaml'

module Safeguard

  # Holds filename => checksum pairs.
  class HashTable

    # Initializes an empty HashTable.
    def initialize
      @table = {}
    end

    # Saves the HashTable to a YAML file.
    def save(filename)
      File.open("#{filename}.yaml", 'w') do |file|
        file.puts to_yaml
      end
    end

    # Loads the HashTable from a YAML file.
    def self.load(filename)
      YAML::load_file "#{filename}.yaml"
    end

    # Associates the given +filename+ to the computed checksum of the file it
    # refers to.
    def <<(filename)
      @table[filename] = Digest.file filename
    end

    alias :add :<<

    # Looks up the checksum for the given +filename+.
    def [](filename)
      @table[filename]
    end

    # Recalculates the hash and compares it to the original hash associated with
    # the given filename.
    #
    # If a hash for the given file isn't stored in this table, an exception will
    # be raised.
    def verify(filename)
      hash = @table[filename]
      raise "File not in repository: #{filename}" unless hash
      Digest.file(filename) == hash
    end

  end

end
