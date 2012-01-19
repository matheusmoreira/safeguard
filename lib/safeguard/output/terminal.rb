require 'safeguard/core_ext/module'
require 'i18n'

module Safeguard
  module Output

    # Encapsulates all terminal output.
    module Terminal

      class << self

        # Appends the given +key+ to this module's translation key and forwards
        # all other arguments to <tt>I18n.translate</tt>.
        def translate(key, *args)
          I18n.t translation_key(key), *args
        end

        # Prints a string before a file is verified without a new line.
        def before_verifying(file, function)
          print translate(:before_verifying, file: file, function: function)
        end

        # Prints a string before a file is hashed without a new line.
        def before_hashing(file, function)
           print translate(:before_hashing, file: file, function: function)
        end

        # Prints a string after a file is hashed with a new line.
        def after_hashing(file, function, result)
          puts translate(:after_hashing, file: file, function: function, result: result)
        end

        # Prints a string after a file is verified with a new line.
        def after_verifying(file, function, result)
          puts translate(:after_verifying, file: file, function: function, result: result)
        end

        # Creates an options ribbon containing containing mappings to this
        # class' methods.
        def create_mappings_for(*keys)
          options = Ribbon.new
          keys.each { |key| options[key] = method key }
          options
        end

      end


    end

  end
end
