module Escort
  module Formatter
    class Commands
      include Enumerable

      class << self
        def command_for(setup, context)
          if context.empty?
            GlobalCommand.new(setup)
          else
            Command.new(context.last, setup, context)
          end
        end
      end

      attr_reader :setup, :context

      def initialize(setup, context)
        @setup = setup
        @context = context
      end

      def each(&block)
        setup.canonical_command_names_for(context).each do |command_name|
          command = Command.new(command_name, setup, context)
          block.call(command)
        end
      end

      def count
        setup.canonical_command_names_for(context).size
      end
      alias_method :size, :count
    end
  end
end
