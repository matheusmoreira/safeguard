require 'safeguard/command'

module Safeguard
  class Command

    # Verifies the files present in a Repository.
    class Verify < Command

      add_supported_algorithms_as_options!

      # Verify the files passed as arguments using information from the
      # Repository in the current directory.
      action do |options, args|
        repo = Repository.new options.dir
        functions = options.functions
        results = repo.verify_files *args, functions: functions,
                                           before_verifying: method(:before_verifying),
                                           after_verifying: method(:after_verifying)
      end

      class << self

        def before_verifying(file, function)
          print "Verifying file '#{file}'... "
        end

        def after_verifying(file, function, result)
          puts result ? :OK : :Mismatch
        end

      end

    end

  end
end
