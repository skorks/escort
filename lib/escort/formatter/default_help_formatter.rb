module Escort
  module Formatter
    class DefaultHelpFormatter
      attr_reader :setup, :context

      def initialize(setup, context)
        @setup = setup
        @context = context
      end

      def print(parser)
        options = Options.new(parser)
        commands = Commands.new(setup, context)
        current_command = Commands.command_for(setup, context)

        TerminalFormatter.display($stdout, Terminal.width) do |d|
          d.puts "NAME"
          d.indent(4) do
            d.table(:columns => 3, :newlines => 1) do |t|
              t.row current_command.script_name, '-', current_command.summary
            end
            d.put(setup.description_for(context), :newlines => 2) if setup.description_for(context)
          end
          d.puts "USAGE"
          d.indent(4) do
            d.put current_command.usage, :newlines => 2
          end
          if setup.version
            d.puts "VERSION"
            d.indent(4) {
              d.put setup.version, :newlines => 2
            }
          end
          if options.count > 0
            d.puts "OPTIONS"
            d.indent(4) {
              d.table(:columns => 3, :newlines => 1) do |t|
                options.each do |option|
                  t.row option.usage, '-', option.description
                end
              end
            }
          end
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
end
