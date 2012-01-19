require 'ribbon'

module Safeguard

  # Something that works behind the scenes, possibly talking to an user
  # interface in the middle of it through callbacks.
  class Worker

    class << self

      # All callbacks defined for this class.
      def callbacks
        @callbacks ||= []
      end

      # Defines callbacks for this class.
      def has_callback(*names)
        callbacks.push *names
        names.map(&:to_sym).each do |callback|
          iv_name = callback.to_s.prepend('@').to_sym
          define_method callback do |&block|
            assign_callback iv_name, &block
          end
        end
      end

      # Same as +has_callback+.
      alias has_callbacks has_callback

    end

    protected

    # Calls the given callback, passing it the rest of the arguments.
    def call_callback(block, *args)
      block.call *args if block.respond_to? :call
    end

    def initialize_callbacks_from(options)
      options = Ribbon.wrap options
      self.class.callbacks.each do |callback|
        send callback, &options.fetch(callback, nil)
      end
    end

    private

    # Sets the callback to the given variable name if the block responds to
    # +call+.
    def assign_callback(name, &block)
      instance_variable_set name, block if block.respond_to? :call
      instance_variable_get name
    end

  end
end
