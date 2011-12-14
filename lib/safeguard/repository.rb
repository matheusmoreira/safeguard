module Safeguard
  class Repository

    DIRECTORY_NAME = '.safeguard'.freeze

    attr_accessor :directory
    alias :dir :directory

    def initialize(dir)
      self.directory = Repository.directory_in(dir)
      FileUtils.mkdir_p directory
    end

    def self.directory_in(dir)
      File.join(dir, DIRECTORY_NAME)
    end

    def self.initialized?(dir)
      File.directory? directory_in(dir)
    end

  end
end
