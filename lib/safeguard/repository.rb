require 'safeguard/hash_table'

module Safeguard

  class Repository

    DIRECTORY_NAME = '.safeguard'.freeze

    HASH_TABLE_FILE_NAME = 'hash_table'.freeze

    attr_accessor :directory
    alias :dir :directory

    def initialize(dir)
      self.directory = Repository.directory_in(dir)
      FileUtils.mkdir_p directory
    end

    def hash_table
      HashTable.load hash_table_file_name rescue HashTable.new
    end

    def hash_table_file_name
      File.join directory, HASH_TABLE_FILE_NAME
    end

    def self.directory_in(dir)
      File.join File.expand_path(dir), DIRECTORY_NAME
    end

    def self.initialized?(dir)
      File.directory? directory_in(dir)
    end

  end
end
