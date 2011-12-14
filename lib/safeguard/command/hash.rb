require 'safeguard/digest'

module Safeguard
  module Command
    module Hash

      Command.register self

      def self.execute(*args)
        args.each do |filename|
          puts "#{Digest.file filename} => #{filename}" if File.file? filename
        end
      end

    end
  end
end
