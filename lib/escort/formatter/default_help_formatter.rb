module Escort
  module Formatter
    class DefaultHelpFormatter
      include Escort::Formatter::Common

      attr_reader :setup, :context

      def initialize(setup, context)
        @setup = setup
        @context = context
      end

      def print(parser)
        option_strings = option_output_strings(parser)
        command_strings = command_output_strings

        TerminalFormatter.display($stdout, Terminal.width) do |d|
          d.puts "NAME"
          d.indent(4) do
            d.table(:columns => 3, :newlines => 1) do |t|
              t.row script_name_with_command, '-', setup.summary_for(context) || ''
            end
            d.put(setup.description_for(context), :newlines => 2) if setup.description_for(context)
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


      private

      def script_name_with_command
        result = []
        result << script_name
        result << current_command unless context.empty?
        result.join(" ")
      end

      def script_name
        File.basename($0)
      end

      def current_command
        context.last || :global
      end

      #def current_command_summary
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
