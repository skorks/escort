module Escort
  class Application
    class << self
      def version(value)
        set_configuration_value(__method__, value)
      end

      def summary(value)
        set_configuration_value(__method__, value)
      end

      def description(value)
        set_configuration_value(__method__, value)
      end

      def command_map(klass = nil, &block)
        if block_given?
          set_configuration_value(__method__, block)
        else
          set_configuration_value(__method__, klass)
        end
      end

      def option_registry(klass = nil, &block)
        if block_given?
          set_configuration_value(__method__, block)
        else
          set_configuration_value(__method__, klass)
        end
      end

      private

      def set_configuration_value(key, value)
        configuration[key.to_s] = value
      end

      def configuration
        @configuration ||= {}
      end
    end

    attr_reader :configuration

    def initialize
      @configuration = self.class.send(:configuration)
      @configuration['option_registry'] ||= Escort::OptionRegistry
      @configuration['command_map'] ||= Escort::CommandMap
    end

    def run
      Executable.new(nil, configuration).run
    end
  end
end
