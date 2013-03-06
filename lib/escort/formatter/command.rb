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

      private

      def alias_string
        @alias_string ||= aliases.join(", ") if has_aliases?
      end
    end
  end
end
