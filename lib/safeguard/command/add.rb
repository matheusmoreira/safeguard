require 'safeguard/command'
require 'safeguard/digest'

module Safeguard
  class Command

    # Adds files to a Repository.
    class Add < Command

      opt :functions, '--use', Symbol,
                      "Algorithm used to calculate the file's checksum. " <<
                      "Currently supported: #{Digest::SUPPORTED_ALGORITHMS.join(', ')}",
                      arity: [1,0], on_multiple: :append

      opt :force, '--force', 'Rehash files that are already in the repository'

      # For every argument, try to add it to the Repository in the current
      # directory.
      action do |options, files|
        repo = Repository.new options.dir
        repo.before_save do
          repo.hash_and_add! *files, functions: options.functions, force: options.force?
        end
      end

    end

  end
end
