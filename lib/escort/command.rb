module Escort
  class Command
    include Dsl

    attr_reader :current_options, :name

    def initialize(name, options_string)
      @name = name
      @options_string = options_string
    end

    def parse_options
      parser = Trollop::Parser.new(&@options_block)
      @current_options = Trollop::with_standard_exception_handling(parser) do
        parser.parse @options_string
      end
    end

    def perform_action(parent_command_options, remaining_arguments)
      @action_block.call(parent_command_options, @current_options, remaining_arguments)
    end
  end
end
