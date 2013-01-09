module Escort
  module Setup
    module Dsl
      #attr_reader :command_names

      def options(&block)
        @options_block = block
      end

      def action(&block)
        @action_block = block
      end

      def validations(&block)
        @validations_block = block
      end

    end
  end
end
