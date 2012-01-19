require 'safeguard/command'
require 'safeguard/output/terminal'
require 'safeguard/repository'
require 'ribbon'

module Safeguard
  class Command

    # Outputs the checksum of files.
    #
    #   $ safeguard hash --sha1 --md5 --crc32 *.mp3
    class Hash < Command

      add_supported_algorithms_as_options!

      # For every argument, outputs its checksum if it exists as a file.
      action do |options, files|
        hasher_options = Ribbon.new functions: options.functions?([])
        mappings = Output::Terminal.create_mappings_for :before_hashing, :after_hashing
        Ribbon.merge! hasher_options, mappings
        Hasher.new(*files, hasher_options).hash_files!
      end

    end

  end
end
