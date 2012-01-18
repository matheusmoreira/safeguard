require 'safeguard/hasher'
require 'safeguard/repository/hash_table'
require 'safeguard/verifier'
require 'fileutils'
require 'ribbon'
require 'ribbon/core_ext'

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

    # This repository's HashTable. Lazily loaded from disk.
    def hash_table
      @table ||= load_hash_table!
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

    # Adds the given files to the repository.
    def add!(*files)
      hash_table.add *files
    end

    # Calculates the checksum of the given files and stores the results. +args+
    # will be used to instantiate a new Hasher.
    #
    # By default, the hashes of files already in the repository will not be
    # recalculated. To force that, call with <tt>:force => true</tt>.
    def hash_and_add!(*args)
      ribbon = args.extract_ribbon!
      funcs = ribbon.functions?
      hasher = Hasher.new *args, functions: funcs
      hasher.files.delete_if do |file|
        hasher.functions.any? { |function| hash_table.has_hash? file, function }
      end unless ribbon.force?
      results = hasher.results
      hash_table.merge! results
    end

    # Creates a Hasher for the files present in this repository.
    def create_hasher_with(functions)
      Hasher.new *hash_table.files, :functions => functions
    end

    # Creates a verifier using this repository's hash table.
    def create_verifier_for(*args)
      ribbon = args.extract_wrapped_ribbon!
      Verifier.new *args, ribbon.merge!(hash_table: hash_table)
    end

    # Recalculates the checksum of the given files and compares them to the
    # stored values. +args+ will be used to instantiate a new Verifier.
    def verify_files(*args)
      create_verifier_for(*args).results
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

    private

    # Loads the hash table from file. Creates a new one if unable to do so.
    def load_hash_table!
      HashTable.load hash_table_file_name
    rescue
      # TODO: handle all error cases properly. This can overwrite a perfectly
      #       good hash table for incredibly sily reasons.
      HashTable.new
    end

  end
end
