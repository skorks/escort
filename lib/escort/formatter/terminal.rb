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
          `/usr/bin/env tput cols`.to_i
        end

        #def curses_width
          #require 'curses'
          #screen_size = self::DEFAULT_WIDTH
          #Curses.init_screen
          #begin
            #screen_size = Curses.cols
          #ensure
            #Curses.close_screen
          #end
          #screen_size
        #end
      end
    end
  end
end
