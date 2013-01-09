require 'readline'

module Escort
  class Arguments
    class << self
      def read(arguments, no_arguments_valid=false)
        if arguments.empty? && !no_arguments_valid
          while command = Readline.readline("> ", true)
            arguments << command
          end
          arguments = arguments.compact.keep_if{|value| value.length > 0}
          #TODO what should be raised here (UserError), should anything
          raise "You must provider some arguments to this script" if arguments.empty?
        end
        arguments
      end
    end
  end
end
