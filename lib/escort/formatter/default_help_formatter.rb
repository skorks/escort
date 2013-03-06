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

        TerminalFormatter.display($stdout, Terminal.width) do |d|
          d.puts "NAME"
          d.indent(4) do
            d.table(:columns => 3, :newlines => 1) do |t|
              t.row script_name_with_command, '-', current_command_summary
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

      def current_command_summary
        setup.summary_for(context) || ''
      end

      #def command_output_strings
        #commands = {}
        #setup.canonical_command_names_for(context).each do |command_name|
          #command_description = setup.command_description_for(command_name, context) || ""
          #command_summary = setup.command_summary_for(command_name, context) || ""
          #command_aliases = setup.command_aliases_for(command_name, context)
          #command_alias_string = command_aliases.join(", ") if command_aliases && command_aliases.size > 0
          #command_string = (command_aliases && command_aliases.size > 0 ? "#{command_name}, #{command_alias_string}" : "#{command_name}" )
          #command_name = command_name.to_s
          #commands[command_name] = [command_string, command_summary, command_description]
        #end
        #commands
      #end
    end
  end
end
