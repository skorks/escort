module Escort
  module Setup
    module Dsl
      class Command
        def initialize(name, options = {}, &block)
          reset
          @name = name
          @description = options[:desc] || ""
          @aliases = [options[:aliases] || []].flatten
          block.call(self) if block_given?
        rescue => e
          STDERR.puts "Problem with syntax of command '#{@name}' configuration"
          #TODO need some way to enable more verbose error output
          #TODO remove this
          STDERR.puts e
          STDERR.puts e.backtrace
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end

        def options(&block)
          @options = Options.new(&block)
        end

        def action(&block)
          @action = Action.new(&block)
        end

        def command(name, options = {}, &block)
          command = Command.new(name.to_sym, options, &block)
          aliases = [options[:aliases] || []].flatten + [name]
          aliases.each do |name|
            @commands[name.to_sym] = command
          end
        end

        def validations(&block)
          @validations = Validations.new(@name, &block)
        end

        private

        def reset
          @commands = {}
          @options = nil
          @action = nil
          @validations = nil
          @name = nil
          @description = nil
          @aliases = []
        end
      end
    end
  end
end
