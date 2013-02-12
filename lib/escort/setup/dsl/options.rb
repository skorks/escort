module Escort
  module Setup
    module Dsl
      class Options
        #TODO options can possibly take a command name param so that we can output which options
        #block we are dealing with if there is an error
        def initialize(&block)
          @options = {}
          block.call(self) if block_given?
        rescue => e
          $stderr.puts "Problem with syntax of options block"
          #TODO a better error in here
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
