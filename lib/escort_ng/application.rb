module Escort
  class Application
    class << self
      def command_map(&block)
        @command_map ||= ::Escort::CommandMap.new
        @command_map.build(&block) if block_given?
        @command_map
      end

      def option_registry(&block)
        @option_registry ||= ::Escort::OptionRegistry.new
        @option_registry.build(&block) if block_given?
        @option_registry
      end

      def executable(option_string = '')
        Executable.new(option_string, command_map, option_registry)
      end
    end
  end
end
