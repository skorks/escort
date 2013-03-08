module Escort
  module Formatter
    class StreamOutputFormatter
      DEFAULT_OUTPUT_WIDTH = 80
      DEFAULT_INDENT_STRING = ' '
      DEFAULT_INDENT = 0

      attr_reader :stream, :indent_string, :current_indent, :max_output_width, :cursor_position

      def initialize(stream = $stdout, options = {}, &block)
        @stream = stream
        @max_output_width = options[:max_output_width] || DEFAULT_OUTPUT_WIDTH
        @indent_string = options[:indent_string] || DEFAULT_INDENT_STRING
        @current_indent = options[:current_indent] || DEFAULT_INDENT
        @cursor_position = CursorPosition.new(@max_output_width)
        block.call(self) if block_given?
      end

      def print(string)
        splitter_input = pad_string_to_account_for_cursor_position(string.to_s)
        segments = StringSplitter.new(max_output_width).split(splitter_input)
        segments = remove_padding_that_account_for_cursor_position(segments)
        segments.each do |segment|
          output_string = "#{current_indent_string}#{segment}"
          output_string = segment unless cursor_position.newline?
          stream.print output_string
          cursor_position.update_for(segment)
          newline if segments.last != segment
        end
      end

      def puts(string, options = {:newlines => 1})
        print(string)
        newline(options[:newlines])
      end

      def newline(newline_count = 1)
        stream.print("\n" * newline_count)
        cursor_position.reset if newline_count > 0
      end

      def indent(count, &block)
        newline unless cursor_position.newline?
        new_indent = current_indent + count
        self.class.new(stream, :max_output_width => max_output_width - count, :indent_string => indent_string, :current_indent => new_indent, &block)
      end

      def grid(options = {}, &block)
        if block_given?
          options[:width] ||= max_output_width
          grid = StringGrid.new(options, &block)
          puts grid.to_s
        end
      end

      private

      def pad_string_to_account_for_cursor_position(string)
        "#{padding_string}#{string}"
      end

      def remove_padding_that_account_for_cursor_position(segments)
        first_string = segments.first
        if first_string
          segments[0] = first_string.sub(/#{padding_string}/, '')
        end
        segments
      end

      def padding_string
        "." * cursor_position.position
      end

      def current_indent_width
        current_indent_string.length
      end

      def current_indent_string
        indent_string * current_indent
      end

      #def table(options = {}, &block)
        #BorderlessTable.new(self, options).output(&block)
        #newline(options[:newlines] || 1)
      #end
    end
  end
end
