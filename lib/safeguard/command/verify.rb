require 'safeguard/command'
require 'safeguard/output/terminal'
require 'ribbon'

module Safeguard
  class Command

    # Verifies the files present in a Repository.
    #
    #   # Verifies all files in repository using SHA1
    #   $ safeguard verify --sha1
    #
    #   # Verifies all files ending in '.mp3' using CRC32
    #   $ safeguard verify --crc32 *.mp3
    class Verify < Command

      add_supported_algorithms_as_options!

      # Verify the files passed as arguments using information from the
      # Repository in the current directory.
      action do |options, files|
        repo = Repository.new options.dir
        functions = options.functions? []
        verifier_options = Ribbon.new functions: functions
        mappings = Output::Terminal.create_mappings_for :before_verifying, :after_verifying
        Ribbon.merge! verifier_options, mappings
        results = repo.verify_files *files, verifier_options
      end

    end

  end
end
