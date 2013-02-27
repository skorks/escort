module Escort
  module Formatter
    class Options
      attr_reader :setup, :context, :parser

      def initialize(setup, context, parser)
        @setup = setup
        @context = context
        @parser = parser
      end
    end
  end
end
