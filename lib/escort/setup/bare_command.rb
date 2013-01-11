module Escort
  module Setup
    class BareCommand
      include Common

      private
      def reset
        common_reset
      end
    end
  end
end
