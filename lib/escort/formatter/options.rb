module Escort
  module Formatter
    class Options
      include Enumerable

      attr_reader :parser

      def initialize(parser)
        @parser = parser
      end

      def each(&block)
        parser.specs.each do |option_name, details|
          option = Option.new(option_name, details)
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
