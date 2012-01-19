require 'safeguard/command/add'
require 'safeguard/output/terminal'
require 'safeguard/repository'
require 'ribbon'

module Safeguard
  class Command
    class Add

      # Hashes files and stores the result in the repository.
      #
      #   $ safeguard add hash --sha1 *.mp3
      class Hash < Add

        add_supported_algorithms_as_options!
        opt :force, 'Rehash files that are already in the repository'

        when_called do |options, files|
          Repository.new(options.dir).before_save do |repo|
            functions = options.functions? []
            hasher_options = Ribbon.new force: options.force?, functions: functions
            mappings = Output::Terminal.create_mappings_for :before_hashing, :after_hashing
            Ribbon.merge! hasher_options, mappings
            repo.hash_and_add! *files, hasher_options
          end
        end

      end
    end
  end
end
