require 'open3'

module Escort
  module Formatter
    class ShellCommandExecutor
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def execute(success_callback = nil, error_callback = nil)
        begin
          stdin, stdout, stderr, thread = ensure_successful_exit do
            Open3.popen3('/usr/bin/env tput cols')
          end
          success_callback.call(command, stdin, stdout, stderr) if success_callback
        rescue => e
          error_callback.call(command, e) if error_callback
          nil
        end
      end

      private

      def ensure_successful_exit(&block)
        stdin, stdout, stderr, thread = block.call
        process_status = $?
          raise Escort::InternalError.new("Shell command exited with a non-zero (#{process_status.exit}) exit code") if process_status.exit != 0
        [stdin, stdout, stderr, thread]
      end
    end
  end
end
