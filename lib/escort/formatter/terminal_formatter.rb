module Escort
  module Formatter
    class TerminalFormatter
      class << self
        def display(stream = $stdout, max_width = Terminal::DEFAULT_WIDTH, &block)
          formatter = self.new(stream, max_width)
          block.call(formatter)
        end
      end

      attr_reader :stream, :indent_char, :indent_count, :terminal_columns

      def initialize(stream = $stdout, max_width = Terminal::DEFAULT_WIDTH)
        @stream = stream
        @indent_char = " "
        @indent_count = 0
        @terminal_columns = (max_width < Terminal::DEFAULT_WIDTH/2 ? Terminal::DEFAULT_WIDTH/2 : max_width)
      end

      def put(data, options = {:newlines => 0})
        segments = StringSplitter.new(terminal_columns - current_indent_string.size - 1).split(data.to_s)
        segments.each do |segment|
          stream.print "#{current_indent_string}#{segment}"
        end
        newline(options[:newlines])
      end

      def puts(data)
        put(data, :newlines => 1)
      end

      def indent(count, &block)
        @indent_count += count
        block.call
        @indent_count -= count
      end

      def table(options = {}, &block)
        BorderlessTable.new(self, options).output(&block)
        newline(options[:newlines] || 1)
      end

      def newline(newline_count = 1)
        stream.print("\n" * newline_count)
      end

      def current_indent_string
        indent_char * indent_count
      end
    end
  end
end
