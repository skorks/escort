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

      def run(option_string = '')
        #raw_cli_options = get_raw_cli_options(option_string)
        #p raw_cli_options
        #parse the option string
        @command_map.executable_for(nil, nil, nil).execute
        #TODO introduce an exit call here when things are further along
      end

      #private

      #def get_raw_cli_options(option_string)
        #passed_in_options = Escort::Utils.tokenize_option_string(option_string)
        #passed_in_options.empty? ? ARGV.dup : passed_in_options
      #end
    end
  end
end
