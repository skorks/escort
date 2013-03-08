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
        segments = StringSplitter.new(max_output_width_given_indent, :first_segment_max_length => next_output_string_max_length).split(string.to_s)
        segments.each do |segment|
          output_string = "#{current_indent_string}#{segment}"
          output_string = segment unless cursor_position.newline?
          stream.print output_string
          cursor_position.update_for(output_string)
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
        self.class.new(stream, :max_output_width => max_output_width, :indent_string => indent_string, :current_indent => current_indent + count, &block)
      end

      def table(options = {}, &block)
        #d.table(:columns => 3, :max_width => 50, :border => [:none, :outer, :inner, :full], :title => 'Hello') do |t|
        #  t.column 1, :padding_left => 1, :padding_right => 1, :halign => center, :valign => center
        #  t.header 'a', 'b', 'c'
        #  t.row 1, 2, 3
        #  t.row 2, 3, 4
        #end
        #merge particular cells in a row
        #merge particular cells in a column
        raise "Not implemented"
      end

      private

      #def on_same_line_from_previous_print?(segment, segments)
        #segment == segments.first && @cursor_position != 0
        #@cursor_position != 0
      #end

      def next_output_string_max_length
        length = max_output_width - cursor_position.position
        length = 0 if length < 0
        length = max_output_width_given_indent if length > max_output_width_given_indent
        length
      end

      def max_output_width_given_indent
        max_output_width - current_indent_width
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
