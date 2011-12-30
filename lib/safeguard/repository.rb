require 'safeguard/repository/hash_table'
require 'fileutils'

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
    def initialize(dir)
      self.directory = Repository.directory_in(dir)
    end

    # Creates a directory for this repository, if one doesn't exist. The
    # directory will have the name defined in the DIRECTORY_NAME constant.
    def create_directory!
      FileUtils.mkdir_p directory
    end

    # Loads this repository's HashTable. Creates a new one if unable to do so.
    def hash_table
      @table ||= (HashTable.load hash_table_file_name rescue HashTable.new)
    end

    # Returns the name of the HashTable file relative to this repository.
    def hash_table_file_name
      File.join directory, HASH_TABLE_FILE_NAME
    end

    # Saves this Repository's HashTable with the filename returned by
    # #hash_table_file_name.
    def save_hash_table
      hash_table.save hash_table_file_name
    end

    # Calls the block and ensures that all data is persisted afterwards.
    def before_save(&block)
      if block.arity == 1 then block.call self else instance_eval &block end
    ensure
      save_hash_table
    end

    # Calculates the checksum of the file and adds associates them in this
    # repository's HashTable.
    def add_checksum_of(file, hash_function)
      hash_table.add file, hash_function
    end

    # Verifies whether or not the file still matches the original version.
    #
    # An exception will be raised if the given file isn't in the repository.
    def verify(filename)
      hash_table.verify filename
    end

    # Verifies all files present in this repository, and returns a hash of
    # results associating a filename with either +true+, when the file is the
    # same as the original version, or +false+, when otherwise.
    #
    # If a block is given, the filename and the result will be yielded.
    def verify_all(&block)
      hash_table.verify_all &block
    end

    # Returns the path to the repository relative to the given +dir+.
    def self.directory_in(dir)
      File.join File.expand_path(dir), DIRECTORY_NAME
    end

    # Checks whether or not this repository's directory has been created and
    # initialized.
    def initialized?
      File.directory? dir
    end

    # Checks whether or not a repository has been created in the given +dir+.
    def self.initialized?(dir)
      File.directory? directory_in(dir)
    end

  end
end
