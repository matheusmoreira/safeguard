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
      File.open(filename, 'rb') do |f|
        @table[filename] = Digest.file f
      end
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
      File.open(filename, 'rb') { |f| Digest.file f } == hash
    end

    # Verifies all files stored in this table and returns a hash of results
    # associating a filename with either +true+, when the file's recalculated
    # hash is equal to the hash stored in this table, or +false+, when
    # otherwise.
    #
    # If a block is given, the filename and the result will be yielded instead.
    def verify_all
      files = @table.keys
      if block_given?
        files.each { |file| yield file, verify(file) }
      else
        {}.tap do |results|
          files.each do |file|
            results[file] = verify file
          end
        end
      end
    end

  end

end
