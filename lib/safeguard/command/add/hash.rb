require 'safeguard/command/add'
require 'safeguard/digest'

module Safeguard
  class Command
    class Add
      class Hash < Add

        add_supported_algorithms_as_options!
        opt :force, 'Rehash files that are already in the repository'

        when_called do |options, files|
          repo = Repository.new options.dir
          repo.before_save do
            repo.hash_and_add! *files, functions: options.functions?([]), force: options.force?
          end
        end

      end
    end
  end
end
