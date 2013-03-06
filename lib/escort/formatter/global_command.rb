module Escort
  module Formatter
    class GlobalCommand < Command
      def initialize(setup)
        super(:global, setup, [])
      end

      def summary
        @summary ||= setup.summary_for(context) || ""
      end

      def description
        @description ||= setup.description_for(context) || ""
      end
    end
  end
end
