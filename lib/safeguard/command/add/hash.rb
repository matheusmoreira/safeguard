require 'safeguard/command/add'
require 'safeguard/digest'

module Safeguard
  class Command
    class Add
      class Hash < Add

        add_supported_algorithms_as_options!
        opt :force, 'Rehash files that are already in the repository'

        when_called do |options, files|
          Repository.new(options.dir).before_save do |repo|
            repo.hash_and_add! *files, functions: options.functions?([]),
                                       force: options.force?,
                                       before_hashing: method(:before_hashing),
                                       after_hashing: method(:after_hashing)
          end
        end

        class << self

          def before_hashing(file, function)
            print "Hashing the file '#{file}' with #{function.to_s.upcase} "
          end

          def after_hashing(file, function, results)
            puts " => #{results}"
          end

        end

      end
    end
  end
end
