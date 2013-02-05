module Escort
  module Formatter
    class DefaultGlobal
      include Escort::Formatter::Common

      attr_reader :setup

      def initialize(setup)
        @setup = setup
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
            two_column_wrapped_at_second(d, script_name.size, script_name, setup.summary || '', :newlines => 2, :separator => " - ")
            d.string(setup.description, 2) if setup.description
          end
          d.string("USAGE", 1)
          d.indent(4) {
            if setup.canonical_command_names_for([]).nil? || setup.canonical_command_names_for([]).length == 0
              d.string("#{script_name} [options] [arguments...]", 2)
            else
              d.string("#{script_name} [global options] command [command options] [arguments...]", 2)
            end
          }
          if setup.version
            d.string("VERSION", 1)
            d.indent(4) {
              d.string(setup.version, 2)
            }
          end
          d.string("GLOBAL OPTIONS", 1)
          d.indent(4) {
            option_strings.each_pair do |key, value|
              two_column_wrapped_at_second(d, option_string_field_width, value[:string], value[:desc] || '', :newlines => 1, :separator => " - ")
            end
            d.newline
          }
          if command_strings.keys.size > 0
            d.string("COMMANDS", 1)
            d.indent(4) {
              command_strings.each_pair do |command_name, values_array|
                two_column_wrapped_at_second(d, command_string_field_width, values_array[0], values_array[1] || '', :newlines => 1, :separator => " - ")
              end
              d.newline
            }
          end
        end
      end

      def command_output_strings
        commands = {}
        context = []
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

      def command_field_width(commands)
        leftcol_width = commands.values.map{|v| v[0]}.map { |s| s.length }.max || 0
        rightcol_start = leftcol_width + 3
      end
    end
  end
end
