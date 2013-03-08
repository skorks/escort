module Escort
  module Formatter
    class CursorPosition
      attr_reader :max_line_width, :position

      def initialize(max_line_width)
        @max_line_width = max_line_width
        reset
      end

      def update_for(string)
        @position += string.length
        raise Escort::InternalError.new("Cursor position for help output is out of bounds") if position > max_line_width
      end

      def newline?
        @position == 0
      end

      def reset
        @position = 0
      end

      def chars_to_end_of_line
        max_line_width - position
      end
    end
  end
end
