module Escort
  module Formatter
    class TerminalFormatter
      DEFAULT_TERMINAL_COLUMNS = 80

      class << self
        def display(stream = STDOUT, max_width = self::DEFAULT_TERMINAL_COLUMNS, &block)
          formatter = self.new(stream)
          block.call(formatter)
        end
      end

      def initialize(stream = STDOUT)
        @stream = stream
        @indent_char = " "
        @indent_count = 0
        @terminal_columns = DEFAULT_TERMINAL_COLUMNS
      end

      def string(string, newline_count = 1)
        @stream.print("#{indent_string}#{wrap(string, @terminal_columns, :prefix => @indent_count)}")
        newline(newline_count)
      end

      def string_with_wrap(string, wrap_column, newline_count = 1)
        @stream.print("#{indent_string}#{wrap(string, @terminal_columns, :prefix => wrap_column)}")
        newline(newline_count)
      end

      def newline(newline_count = 1)
        @stream.print("\n" * newline_count)
      end

      def indent(count_chars = 2, indent_char = " ", &block)
        @previous_indent_count = @indent_count
        @previous_indent_char = @indent_char
        @indent_count += count_chars
        @indent_char = indent_char
        block.call
        @indent_count = @previous_indent_count
        @indent_char = @previous_indent_char
      end

      def current_indent
        @indent_count
      end

      private

      def wrap(string, width = DEFAULT_TERMINAL_COLUMNS, opts={})
        return string if string.length < width - 1
        string.split("\n").map { |s| wrap_string(s, width, opts) }.flatten.join("\n")
      end

      def wrap_string(string, width = DEFAULT_TERMINAL_COLUMNS, opts={})
        prefix = opts[:prefix] || 0
        width = width - 1
        start = 0
        ret = []
        until start > string.length
          nextt =
            if start + width >= string.length
              string.length
            else
              x = string.rindex(/\s/, start + width)
              x = string.index(/\s/, start) if x && x < start
              x || string.length
            end
          ret << (ret.empty? ? "" : " " * prefix) + string[start ... nextt]
          start = nextt + 1
        end
        ret
      end

      def indent_string
        @indent_char * @indent_count
      end
    end
  end
end
