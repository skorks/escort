module Escort
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

  class DefaultFormatter
    attr_reader :global_setup_accessor

    def initialize(global_setup_accessor)
      @global_setup_accessor = global_setup_accessor
    end

    def print(parser)
      script_name = File.basename($0)
      options = parser.specs
      option_strings = option_output_strings(parser)
      option_string_field_width = option_field_width(option_strings)
      command_strings = command_output_strings
      command_string_field_width = command_field_width(command_strings)

      TerminalFormatter.display do |d|
        d.string("NAME", 1)
        d.indent(4) do
          d.string("#{script_name} - Describe your application here", 2) #$0 is the name of the currently executing script
          d.string("Some kind of really long description blah blah blah blah blah blah jjjjjjjjjjjjjjjjjjjjjj jjjjjjjjjjjjjjjjjjj jjjjjjjjjjjjjjjjjjjjj jjjjjjjjjjjjasdfadfadfafad", 2)
        end
        d.string("USAGE", 1)
        d.indent(4) {
          if global_setup_accessor.command_names.nil? || global_setup_accessor.command_names.length == 0
            d.string("#{script_name} [options] [arguments...]", 2)
          else
            d.string("#{script_name} [global options] command [command options] [arguments...]", 2)
          end
        }
        if global_setup_accessor.version
          d.string("VERSION", 1)
          d.indent(4) {
            d.string(global_setup_accessor.version, 2)
          }
        end
        d.string("GLOBAL OPTIONS", 1)
        d.indent(4) {
          option_strings.each_pair do |key, value|
            output_string = "%-#{option_string_field_width}s - %s" % [value, options[key][:desc]]
            description_wrap = option_string_field_width + d.current_indent + 3
            d.string_with_wrap(output_string, description_wrap, 1)
          end
          d.newline
        }
        d.string("COMMANDS", 1)
        d.indent(4) {
          command_strings.each_pair do |command_name, values_array|
            output_string = "%-#{command_string_field_width}s - %s" % [values_array[0], values_array[1]]
            description_wrap = command_string_field_width + d.current_indent + 3
            d.string_with_wrap(output_string, description_wrap, 1)
          end
          d.newline
        }
      end
    end

    def command_output_strings
      commands = {}
      global_setup_accessor.command_aliases.each_pair do |command_name, command_aliases|
        command_name = command_name.to_s
        command_description = global_setup_accessor.command_descriptions[command_name] || ""
        command_alias_string = command_aliases.join(", ") if command_aliases && command_aliases.size > 0
        command_string = (command_aliases && command_aliases.size > 0 ? "#{command_name}, #{command_alias_string}" : "#{command_name}" )
        commands[command_name] = [command_string, command_description]
      end
      commands
    end

    def command_field_width(commands)
      leftcol_width = commands.values.map{|v| v[0]}.map { |s| s.length }.max || 0
      rightcol_start = leftcol_width + 3
    end

    def option_output_strings(parser)
      options = {}
      parser.specs.each do |name, spec|
        options[name] = "--#{spec[:long]}" +
          (spec[:type] == :flag && spec[:default] ? ", --no-#{spec[:long]}" : "") +
          (spec[:short] && spec[:short] != :none ? ", -#{spec[:short]}" : "") +
          case spec[:type]
          when :flag; ""
          when :int; " <i>"
          when :ints; " <i+>"
          when :string; " <s>"
          when :strings; " <s+>"
          when :float; " <f>"
          when :floats; " <f+>"
          when :io; " <filename/uri>"
          when :ios; " <filename/uri+>"
          when :date; " <date>"
          when :dates; " <date+>"
          end
      end
      options

      #leftcol_width = options.values.map { |s| s.length }.max || 0
      #rightcol_start = leftcol_width + 6 # spaces
    end

    def option_field_width(option_strings)
      leftcol_width = option_strings.values.map { |s| s.length }.max || 0
      rightcol_start = leftcol_width + 6
    end
  end
end
