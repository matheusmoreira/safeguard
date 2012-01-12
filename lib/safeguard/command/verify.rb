require 'safeguard/command'

module Safeguard
  class Command

    # Verifies the files present in a Repository.
    class Verify < Command

      opt :functions, '--use', Symbol,
                      "Algorithm used to calculate the file's checksum. " <<
                      "Currently supported: #{Digest::SUPPORTED_ALGORITHMS.join(', ')}",
                      arity: [1,0], on_multiple: :append

      # Verify the files passed as arguments using information from the
      # Repository in the current directory.
      action do |options, args|
        repo = Repository.new options.dir
        functions = options.functions
        results = repo.verify_files *args, functions: functions
        results.keys.each do |file|
          puts "#{file}:"
          results[file].keys.each do |function|
            value = results[file][function]
            value = "File not in repository" if value == :file_missing
            value = "Hash not in repository" if value == :hash_missing
            puts "\t#{function} => #{value}"
          end
        end
      end

    end

  end
end
