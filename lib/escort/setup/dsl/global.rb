module Escort
  module Setup
    module Dsl
      class Global
        def initialize(&block)
          reset
          block.call(self)
        rescue => e
          STDERR.puts "Problem with syntax of app global configuration"
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
          @validations = Validations.new(&block)
        end

        private

        def reset
          @commands = {}
          @options = nil
          @action = nil
        end
      end
    end
  end
end
