module Safeguard
  module CoreExt

    # Ruby core extensions for the Module class.
    module Module

      def translation_key(*args)
        name.split('::').push(*args).map(&:to_s).map(&:downcase).join '.'
      end

    end

    ::Module.send :include, Safeguard::CoreExt::Module

  end
end
