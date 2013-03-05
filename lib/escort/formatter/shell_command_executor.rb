require 'open3'

module Escort
  module Formatter
    class ShellCommandExecutor
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def execute_in_current_shell(success_callback = nil, error_callback = nil)
        begin
          result = `#{command}`
          process_status = $?
          raise Escort::InternalError.new("Shell command exited with a non-zero (#{process_status.exitstatus}) exit code") if process_status.exitstatus != 0
          success_callback.call(command, result) if success_callback
        rescue => e
          error_callback.call(command, e) if error_callback
          nil
        end
      end

      def execute_in_new_shell(success_callback = nil, error_callback = nil)
        stdin, stdout, stderr = nil, nil, nil
        begin
          stdin, stdout, stderr, thread = ensure_successful_exit do
            Open3.popen3(command)
          end
          success_callback.call(command, stdin, stdout, stderr) if success_callback
        rescue => e
          error_callback.call(command, e) if error_callback
          nil
        ensure
          [stdin, stdout, stderr].each {|io| io.close if io}
        end
      end

      private

      def ensure_successful_exit(&block)
        stdin, stdout, stderr, thread = block.call
        process_status = thread.value
        raise Escort::InternalError.new("Shell command exited with a non-zero (#{process_status.exitstatus}) exit code") if process_status.exitstatus != 0
        [stdin, stdout, stderr, thread]
      end
    end
  end
end
