module Escort
  module Formatter
    class StringSplitter
      attr_reader :max_segment_width  #, :first_segment_max_length

      def initialize(max_segment_width, options = {})
        @max_segment_width = max_segment_width
        #@first_segment_max_length = options[:first_segment_max_length] || max_segment_width
      end

      def split(input_string)
        input_strings = input_string.split("\n")
        [split_strings(input_strings)].flatten
        #first_string = strings.shift
        #other_strings = strings
        #result = [split_first_string(first_string) + split_strings(other_strings)].flatten
        #result
      end

      private

      #def split_first_string(string)
        #if first_segment_max_length >= string.length
          #split_string(string)
        #else
          #first = string.slice(0, first_segment_max_length)
          #last = string.slice(first_segment_max_length..-1)
          #split_strings([first, last])
        #end
      #end

      def split_strings(strings)
        strings.map { |s| split_string(s) }
      end

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
