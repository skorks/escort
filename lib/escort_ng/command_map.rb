module Escort
  class CommandMap
    DEFAULT_KEY = '__default__'

    class << self
      def default_command(klass = nil, &block)
        if block_given?
          configuration[DEFAULT_KEY] = block
        else
          configuration[DEFAULT_KEY] = klass
        end
      end

      private

      def configuration
        @configuration ||= {}
      end
    end

    attr_reader :configuration

    def initialize
      @configuration = self.class.send(:configuration)
    end

    #def build(&block)
      #dsl = self.class::DSL.new(self)
      #yield(dsl) if block_given?
      #self
    #end

    #def has_command_for?(key)
      #@commands[key] != nil
    #end

    #def command_for(key)
      #@commands[key]
    #end

    #def set_command(key, value)
      #@commands[key] = value
    #end
  end
end
