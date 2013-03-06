module Escort
  module Formatter
    class DefaultHelpFormatter
      attr_reader :setup, :context

      def initialize(setup, context)
        @setup = setup
        @context = context
      end

      def print(parser)
        options = Options.new(parser, setup, context)
        commands = Commands.new(setup, context)
        current_command = Commands.command_for(setup, context)

        TerminalFormatter.display($stdout, Terminal.width) do |d|
          name_help(current_command, d)
          usage_help(current_command, d)
          version_help(current_command, d)
          options_help(options, d)
          commands_help(commands, d)
        end
      end

      private

      def name_help(current_command, d)
        d.puts "NAME"
        d.indent(4) do
          d.table(:columns => 3, :newlines => 1) do |t|
            t.row current_command.script_name, '-', current_command.summary
          end
          d.put(setup.description_for(context), :newlines => 2) if setup.description_for(context)
        end
      end

      def usage_help(current_command, d)
        d.puts "USAGE"
        d.indent(4) do
          d.put current_command.usage, :newlines => 2
        end
      end

      def version_help(current_command, d)
        if setup.version
          d.puts "VERSION"
          d.indent(4) {
            d.put setup.version, :newlines => 2
          }
        end
      end

      def options_help(options, d)
        if options.count > 0
          d.puts "OPTIONS"
          d.indent(4) {
            d.table(:columns => 3, :newlines => 1) do |t|
              options.each do |option|
                t.row option.usage, '-', option.description
                option_conflicts_help(option, t)
                option_dependencies_help(option, t)
                option_validations_help(option, t)
              end
            end
          }
        end
      end

      def option_conflicts_help(option, t)
        if option.has_conflicts?
          t.row '', '', "- #{option.conflicts}"
        end
      end

      def option_dependencies_help(option, t)
        if option.has_dependencies?
          t.row '', '', "- #{option.dependencies}"
        end
      end

      def option_validations_help(option, t)
        if option.has_validations?
          t.row '', '', "- #{option.validations}"
        end
      end

      def commands_help(commands, d)
        if commands.count > 0
          d.puts "COMMANDS"
          d.indent(4) {
            d.table(:columns => 3, :newlines => 1) do |t|
              commands.each do |command|
                t.row command.name_with_aliases, '-', command.outline
              end
            end
          }
        end
      end
    end
  end
end
