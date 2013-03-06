module Escort
  module Formatter
    class Options
      include Enumerable

      attr_reader :parser, :setup, :context

      def initialize(parser, setup, context)
        @parser = parser
        @setup = setup
        @context = context
      end

      def each(&block)
        parser.specs.each do |option_name, details|
          option = Option.new(option_name, details, setup, context)
          block.call(option)
        end
      end

      def count
        parser.specs.keys.size
      end
      alias_method :size, :count
    end
  end
end
