module Escort
  class App
    include Dsl
    include GlobalDsl

    class << self
      def create(options_string = nil, &block)
        self.new(options_string).tap do |app|
          block.call(app)  #run the block to get the various sub blocks
          begin
            app.parse_options # parse the global options
            app.current_command.parse_options # parse the current command options
            app.execute_before_block(app.current_command.name, app.current_options, app.current_command.current_options, app.arguments)
            app.current_command.perform_action(app.current_options, app.arguments)
          rescue => e
            app.execute_error_block(e)
          end
        end
      end
    end

    attr_reader :current_options

    def initialize(options_string = nil)
      @options_string = options_string || ARGV.dup
    end

    def arguments
      @options_string
    end

    def parse_options
      parser = Trollop::Parser.new(&@options_block)
      parser.stop_on(@command_names)

      @current_options = Trollop::with_standard_exception_handling(parser) do
        parser.parse @options_string
      end
    end

    def current_command
      return @current_command if @current_command
      command_name = @options_string.shift.to_s
      command_block = @command_blocks[command_name]
      @current_command = Command.new(command_name, @options_string)
      command_block.call(@current_command)
      @current_command
    end

    def execute_before_block(command_name, global_options, command_options, arguments)
      @before_block.call(command_name, global_options, command_options, arguments) if @before_block
    end

    def execute_error_block(error)
      @error_block.call(error)
    end
  end
end
