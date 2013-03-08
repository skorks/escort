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

        StreamOutputFormatter.new($stdout, :max_output_width => Terminal.width) do |f|
          name_help(current_command, f)
          usage_help(current_command, f)
          version_help(current_command, f)
          options_help(options, f)
          commands_help(commands, f)
        end
      end

      private

      def name_help(current_command, f)
        f.puts "NAME"
        f.indent(4) do |f|
          f.grid(:columns => 3) do |t|
            t.row current_command.script_name, '-', setup.summary_for(context)
          end
          f.newline
          f.puts(setup.description_for(context), :newlines => 2) if setup.description_for(context)
        end
      end

      def usage_help(current_command, f)
        f.puts "USAGE"
        f.indent(4) do |f|
          f.puts current_command.usage, :newlines => 2
        end
      end

      def version_help(current_command, f)
        if setup.version
          f.puts "VERSION"
          f.indent(4) do |f|
            f.puts setup.version, :newlines => 2
          end
        end
      end

      def options_help(options, f)
        if options.count > 0
          f.puts "OPTIONS"
          f.indent(4) do |f|
            f.grid(:columns => 3) do |t|
              options.each do |option|
                t.row option.usage, '-', option.description
                option_conflicts_help(option, t)
                option_dependencies_help(option, t)
                option_validations_help(option, t)
              end
            end
            f.newline
          end
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
          option.validations.each do |validation|
            t.row '', '', "- #{validation}"
          end
        end
      end

      def commands_help(commands, f)
        if commands.count > 0
          f.puts "COMMANDS"
          f.indent(4) do |f|
            f.grid(:columns => 3) do |t|
              commands.each do |command|
                t.row command.name_with_aliases, '-', command.outline
              end
            end
            f.newline
          end
        end
      end
    end
  end
end
