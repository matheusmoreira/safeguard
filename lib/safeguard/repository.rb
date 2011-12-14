require 'safeguard/hash_table'

module Safeguard

  # Directory which holds file-related data.
  class Repository

    # Name of the directory in which the Safeguard repository resides.
    DIRECTORY_NAME = '.safeguard'.freeze

    # Name of the file to which the HashTable is saved.
    HASH_TABLE_FILE_NAME = 'hash_table'.freeze

    attr_accessor :directory
    alias :dir :directory

    # Initializes a Safeguard repository in or from the given directory.
    #
    # If the given directory does not contain a repository directory, whose name
    # is defined by the DIRECTORY_NAME constant, it will be created.
    def initialize(dir)
      self.directory = Repository.directory_in(dir)
      FileUtils.mkdir_p directory
    end

    # Loads this repository's HashTable. Creates a new one if unable to do so.
    def hash_table
      HashTable.load hash_table_file_name rescue HashTable.new
    end

    # Returns the name of the HashTable file relative to this repository.
    def hash_table_file_name
      File.join directory, HASH_TABLE_FILE_NAME
    end

    # Returns the path to the repository relative to the given +dir+.
    def self.directory_in(dir)
      File.join File.expand_path(dir), DIRECTORY_NAME
    end

    # Checks whether or not a repository has been created in the given +dir+.
    def self.initialized?(dir)
      File.directory? directory_in(dir)
    end

  end
end
