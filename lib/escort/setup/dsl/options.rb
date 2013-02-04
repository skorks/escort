module Escort
  module Setup
    module Dsl
      class Options
        def initialize(&block)
          @options = {}
          block.call(self) if block_given?
        rescue => e
          STDERR.puts "Problem with syntax of global options block"
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end

        def opt(name, desc="", opts={})
          opts[:desc] ||= desc
          @options[name] ||= opts
        end
      end
    end
  end
end
