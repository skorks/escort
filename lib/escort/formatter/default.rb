module Escort
  module Formatter
    class Default
      include Escort::Formatter::Common

      attr_reader :setup, :context

      def initialize(setup, context)
        @setup = setup
        @context = context
      end

      #options = parser.specs
      def print(parser)
        require 'curses'
        Curses.init_screen
        screen_size = Curses.cols
        Curses.close_screen
        p screen_size

        option_strings = option_output_strings(parser)
        command_strings = command_output_strings

        TerminalFormatter2.display($stdout, screen_size) do |d|
          d.puts "NAME"
          d.indent(4) do
            d.table(:columns => 3, :newlines => 1) do |t|
              t.row script_name, '-', setup.summary || ''
            end
            d.put(setup.description, :newlines => 2) if setup.description
          end
          d.puts "USAGE"
          d.indent(4) do
            context_usage_part = context.map { |command_name| "#{command_name} [#{command_name} options]" }.join(" ")
            context_usage_part ||= ""
            nested_command_part = "command [command options]" if !setup.canonical_command_names_for(context).nil? && setup.canonical_command_names_for(context).length > 0
            nested_command_part ||= ""
            usage_string = "#{script_name} [options] #{context_usage_part} #{nested_command_part} [arguments...]".gsub(/\s+/, ' ')
            d.put usage_string, :newlines => 2
          end
          if setup.version
            d.puts "VERSION"
            d.indent(4) {
              d.put setup.version, :newlines => 2
            }
          end
          if option_strings.keys.size > 0
            d.puts "OPTIONS"
            d.indent(4) {
              d.table(:columns => 3, :newlines => 1) do |t|
                option_strings.each_pair do |key, value|
                  t.row value[:string], '-', value[:desc] || ''
                end
              end
            }
          end
          if command_strings.keys.size > 0
            d.puts "COMMANDS"
            d.indent(4) {
              d.table(:columns => 3, :newlines => 1) do |t|
                command_strings.each_pair do |command_name, values_array|
                  t.row values_array[0], '-', values_array[1] || ''
                end
              end
            }
          end
        end
      end

      class TerminalFormatter2
        DEFAULT_TERMINAL_COLUMNS = 80

        class << self
          def display(stream = $stdout, max_width = self::DEFAULT_TERMINAL_COLUMNS, &block)
            formatter = self.new(stream, max_width)
            block.call(formatter)
          end
        end

        attr_reader :stream, :indent_char, :indent_count, :terminal_columns

        def initialize(stream = $stdout, max_width = self::DEFAULT_TERMINAL_COLUMNS)
          @stream = stream
          @indent_char = " "
          @indent_count = 0
          @terminal_columns = (max_width < DEFAULT_TERMINAL_COLUMNS/2 ? DEFAULT_TERMINAL_COLUMNS/2 : max_width)
        end

        def put(data, options = {:newlines => 0})
          segments = Escort::Formatter::StringSplitter.new(terminal_columns - current_indent_string.size - 1).split(data.to_s)
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

      class BorderlessTable
        attr_reader :column_count, :formatter
        attr_accessor :rows

        def initialize(formatter, options = {})
          @formatter = formatter
          @column_count = options[:columns] || 3
          @rows = []
        end

        def row(*column_values)
          rows << column_values.map(&:to_s)
          #TODO raise error if column values size doesn't match columns
        end

        def output(&block)
          block.call(self)

          rows.each do |cells|
            virtual_row = normalize_virtual_row(virtual_row_for(cells))
            physical_row_count_for(virtual_row).times do |physical_count|
              physical_row = format_physical_row_values(physical_row_for(virtual_row, physical_count))
              formatter.put physical_row.join("").chomp, :newlines => 1
            end
          end
        end

        private

        def format_physical_row_values(physical_row)
          physical_row.each_with_index.map do |value, index|
            cell_value(value, index)
          end
        end

        def physical_row_for(virtual_row, index)
          virtual_row.map {|physical| physical[index]}
        end

        def virtual_row_for(column_values)
          virtual_row = []
          column_values.each_with_index do |cell, index|
            virtual_row << Escort::Formatter::StringSplitter.new(column_width(index) - 1).split(cell)
          end
          normalize_virtual_row(virtual_row)
        end

        def normalize_virtual_row(virtual_row)
          virtual_row.map do |physical|
            while physical.size < physical_row_count_for(virtual_row)
              physical << ""
            end
            physical
          end
        end

        def physical_row_count_for(virtual_row)
          virtual_row.map {|physical| physical.size}.max
        end

        def column_width(column_index)
          #TODO raise error if index out of bounds
          width = fair_column_width(column_index)
          if column_index == column_count - 1
            width = last_column_width
          end
          width
        end

        def fair_column_width(index)
          #TODO raise error if index out of bounds
          width = values_in_column(index).map(&:length).max
          width = width + 1
          width > max_column_width ? max_column_width : width
        end

        def last_column_width
          full_fair_column_width = max_column_width * column_count
          all_but_last_fair_column_width = 0
          (column_count - 1).times do |index|
            all_but_last_fair_column_width += fair_column_width(index)
          end
          full_fair_column_width - all_but_last_fair_column_width
        end

        def values_in_column(column_index)
          #TODO raise error if index out of bounds
          rows.map{|cells| cells[column_index]}
        end

        def max_column_width
          (formatter.terminal_columns - 1 - formatter.current_indent_string.length)/column_count
        end

        def cell_value(value, column_index)
          sprintf("%-#{column_width(column_index)}s", value.strip)
        end
      end

      private

      def script_name
        File.basename($0)
      end

      #def current_command
        #context.last || :global
      #end

      def command_output_strings
        commands = {}
        setup.canonical_command_names_for(context).each do |command_name|
          command_description = setup.command_description_for(command_name, context) || ""
          command_aliases = setup.command_aliases_for(command_name, context)
          command_alias_string = command_aliases.join(", ") if command_aliases && command_aliases.size > 0
          command_string = (command_aliases && command_aliases.size > 0 ? "#{command_name}, #{command_alias_string}" : "#{command_name}" )
          command_name = command_name.to_s
          commands[command_name] = [command_string, command_description]
        end
        commands
      end
    end
  end
end
