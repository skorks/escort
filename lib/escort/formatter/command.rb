module Escort
  module Formatter
    class Command
      attr_reader :setup, :context, :name

      def initialize(command_name, setup, context)
        @setup = setup
        @context = context
        @name = command_name.to_sym
      end

      def name_with_aliases
        [name, aliases].flatten.join(", ")
      end

      def outline
        summary.empty? ? description : summary
      end

      def description
        @description ||= setup.command_description_for(name, context) || ""
      end

      def summary
        @summary ||= setup.command_summary_for(name, context) || ""
      end

      def aliases
        @aliases ||= setup.command_aliases_for(name, context)
      end

      def has_aliases?
        aliases && aliases.size > 0 ? true : false
      end

      def script_name
        [canonical_script_name, context].flatten.join(" ")
      end

      def child_commands
        @child_commands ||= setup.canonical_command_names_for(context) || []
      end

      def has_child_commands?
        child_commands.length > 0
      end

      def requires_arguments?
        @requires_arguments ||= setup.arguments_required_for(context)
      end

      def usage
        [script_name_usage_string, parent_commands_usage_string, child_command_usage_string, arguments_usage_string].flatten.reject(&:empty?).join(" ")
      end

      private

      def script_name_usage_string
        "#{canonical_script_name} [options]"
      end

      def parent_commands_usage_string
        context.map{|command_name| command_with_options(command_name)}.join(" ")
      end

      def child_command_usage_string
        has_child_commands? ? "command [command_options]" : ""
      end

      def arguments_usage_string
        requires_arguments? ? "arguments" : "[arguments]"
      end

      def command_with_options(command_name)
        "#{command_name} [#{command_name}_options]"
      end

      def canonical_script_name
        File.basename($0)
      end

      def alias_string
        @alias_string ||= aliases.join(", ") if has_aliases?
      end
    end
  end
end
