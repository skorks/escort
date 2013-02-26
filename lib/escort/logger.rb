require 'logger'

module Escort
  class Logger
    class << self
      def close
        error.close
        output.close
      end

      def error
        @error_logger ||= ::Logger.new($stderr).tap do |l|
          #l.formatter = advanced_error_formatter
          l.formatter = basic_error_formatter
          l.sev_threshold = ::Logger::WARN
        end
      end

      def output
        @output_logger ||= ::Logger.new($stdout).tap do |l|
          l.formatter = output_formatter
          l.sev_threshold = ::Logger::DEBUG
          l.instance_eval do
            def puts(message = nil, &block)
              if block_given?
                fatal(&block)
              else
                fatal(message || "")
              end
            end
          end
        end
      end

      def setup_error_logger(auto_options)
        error.formatter = send(:"#{auto_options.error_formatter}_error_formatter")
        error.sev_threshold = ::Logger.const_get(auto_options.verbosity)
      end

      private

      def basic_error_formatter
        proc do |severity, datetime, progname, msg|
          "\"#{msg2str(msg)}\"\n"
        end
      end

      #"#{severity} [#{datetime.strftime("%d/%b/%Y %H:%M:%S")}] \"#{msg}\"\n"
      def advanced_error_formatter
        proc do |severity, datetime, progname, msg|
          sprintf("%-8s \"#{msg2str(msg, 10)}\"\n", severity)
        end
      end

      def output_formatter
        proc do |severity, datetime, progname, msg|
          "\"#{msg}\"\n"
        end
      end

      def msg2str(msg, backtrace_indent = 0)
        case msg
        when ::String
          msg
        when ::Exception
          "#{msg.message} (#{ msg.class })\n" <<
          (msg.backtrace || []).map{|line| sprintf("%#{backtrace_indent}s#{line}", " ")}.join("\n")
        else
          msg.inspect
        end
      end
    end
  end
end

