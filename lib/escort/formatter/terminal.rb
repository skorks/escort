module Escort
  module Formatter
    class Terminal
      DEFAULT_WIDTH = 80

      class << self
        def width
          tput_width
        end

        private

        def tput_width
          #TODO make this more robust and test this as well
          `/usr/bin/env tput cols`.to_i
        end
      end
    end
  end
end
