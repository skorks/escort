module Escort
  module Setup
    module Common
      def options(&block)
        @options_block = block
      end

      def action(&block)
        @action_block = block
      end

      def validations(&block)
        @validations_block = block
      end

      private

      def common_reset
        @options_block = nil
        @action_block = nil
        @validations_block = nil
      end
    end
  end
end
