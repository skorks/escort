module Escort
  module Formatter
    class StringSplitter
      attr_reader :max_segment_width

      def initialize(max_segment_width)
        @max_segment_width = max_segment_width
      end

      def split(string)
        string.split("\n").map { |s| split_string(s) }.flatten
      end

      private

      def split_string(string)
        result = []
        if string.length > max_segment_width
          first_part = string.slice(0, max_segment_width)
          second_part = string.slice(max_segment_width..-1)
          result << first_part
          result << split_string(second_part)
        else
          result << string
        end
        result
      end
    end
  end
end
