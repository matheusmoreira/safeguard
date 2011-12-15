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
        args.each do |filename|
          puts "#{filename} " + if repo.verify filename
            'OK'
          else
            'Mismatch'
          end
        end
      end

    end

  end
end
