module Escort
  module Formatter
    class DefaultCommand
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

        TerminalFormatter.display do |d|
          d.string("NAME", 1)
          d.indent(4) do
            two_column_wrapped_at_second(d, command_setup_accessor.command_name.size, command_setup_accessor.command_name, command_setup_accessor.command_description || '', :newlines => 2, :separator => " - ")
          end
          d.string("SYNOPSIS", 1)
          d.indent(4) {
            d.string("#{script_name} [global options] #{command_setup_accessor.command_name} [command options] [arguments...]", 2)
          }
          d.string("COMMAND OPTIONS", 1)
          d.indent(4) {
            option_strings.each_pair do |key, value|
              two_column_wrapped_at_second(d, option_string_field_width, value[:string], value[:desc] || '', :newlines => 1, :separator => " - ")
            end
            d.newline
          }
        end
      end
    end
  end
end
