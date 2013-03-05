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
          ShellCommandExecutor.new('/usr/bin/env tput cols').execute_in_current_shell(tput_cols_command_success_callback, tput_cols_command_error_callback) || DEFAULT_WIDTH
        end

        def tput_cols_command_success_callback
          lambda {|command, result| result.to_i}
        end

        def tput_cols_command_error_callback
          lambda do |command, e|
            error_logger.debug {e}
            error_logger.info {"Unable to find terminal width via '#{command}', using default of #{DEFAULT_WIDTH}"}
          end
        end
      end
    end
  end
end
