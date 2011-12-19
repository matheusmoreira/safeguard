require 'safeguard/command'

module Safeguard
  class Command

    # Verifies the files present in a Repository.
    class Verify < Command

      # Verify the files passed as arguments using information from the
      # Repository in the current directory.
      action do |options, args|
        repo = Repository.new options.dir
        if args.empty?
          repo.verify_all do |filename, result|
            display_result filename, result
          end
        else
          args.each do |filename|
            begin
              result = repo.verify filename
              display_result filename, result
             rescue => e
              puts e.message
             end
          end
        end
      end

      def self.display_result(filename, result)
        puts "#{filename} => #{result ? 'OK' : 'Mismatch'}"
      end

    end

  end
end
