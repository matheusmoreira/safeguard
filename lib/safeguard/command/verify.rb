require 'safeguard/command'

module Safeguard
  module Command

    # Verifies the files present in a Repository.
    module Verify

      Command.register self

      # Verify the files passed as arguments using information from the
      # Repository in the current directory.
      def self.execute(*args)
        repo = Repository.new Dir.pwd
        if args.empty?
          repo.verify_all do |filename, result|
            display_result filename, result
          end
        else
          args.each do |filename|
            result = repo.verify filename
            display_result filename, result
          end
        end
      end

      def self.display_result(filename, result)
        puts "#{filename} => #{result ? 'OK' : 'Mismatch'}"
      end

    end

  end
end
