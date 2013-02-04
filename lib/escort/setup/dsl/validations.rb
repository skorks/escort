module Escort
  module Setup
    module Dsl
      class Validations
        def initialize(command_name = nil, &block)
          reset
          @command_name = command_name
          block.call(self) if block_given?
        rescue => e
          if @command_name
            STDERR.puts "Problem with syntax of #{@command_name} command validation block"
          else
            STDERR.puts "Problem with syntax of global validation block"
          end
          #TODO need some way to enable more verbose error output
          #TODO remove this
          STDERR.puts e
          STDERR.puts e.backtrace
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end

        def validate(name, description, &block)
          @validations[name] = {:desc => description, :block => block}
        end

        def opt(name, desc="", opts={})
          opts[:desc] ||= desc
          @options[name] ||= opts
        end

        private

        def reset
          @validations = {}
          @command_name = nil
        end
      end
    end
  end
end
