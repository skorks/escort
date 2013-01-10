module Escort
  module Formatter
    module Common

      private

      def two_column_wrapped_at_second(display, left_column_max, column1, column2, options = {})
        options = {:newlines => 1, :separator => ""}.merge!(options)
        wrap_at = wrap_for_column_at(left_column_max, display.current_indent, options[:separator].length)
        display.string_with_wrap("%-#{left_column_max}s#{options[:separator]}#{column2}" % column1, wrap_at, options[:newlines])
      end

      def wrap_for_column_at(left_column_max, indent, extras)
        left_column_max + indent + extras
      end

      def option_output_strings(parser)
        options = {}
        parser.specs.each do |name, spec|
          options[name] = "--#{spec[:long]}" +
          (spec[:type] == :flag && spec[:default] ? ", --no-#{spec[:long]}" : "") +
          (spec[:short] && spec[:short] != :none ? ", -#{spec[:short]}" : "") +
          case spec[:type]
          when :flag; ""
          when :int; " <i>"
          when :ints; " <i+>"
          when :string; " <s>"
          when :strings; " <s+>"
          when :float; " <f>"
          when :floats; " <f+>"
          when :io; " <filename/uri>"
          when :ios; " <filename/uri+>"
          when :date; " <date>"
          when :dates; " <date+>"
          end
        end

        parser.order.each do |what, opt|
          if what == :text
            next
          end
          spec = parser.specs[opt]
          desc = spec[:desc] + begin
            default_s = case spec[:default]
            when $stdout; "<stdout>"
            when $stdin; "<stdin>"
            when $stderr; "<stderr>"
            when Array
              spec[:default].join(", ")
            else
              spec[:default].to_s
            end

            if spec[:default]
              if spec[:desc] =~ /\.$/
                " (Default: #{default_s})"
              else
                " (default: #{default_s})"
              end
            else
              ""
            end
          end
          options[opt] = {:string => options[opt]}
          options[opt][:desc] = desc
        end
        options
      end

      def option_field_width(option_strings)
        leftcol_width = option_strings.values.map{|v| v[:string]}.map { |s| s.length }.max || 0
        rightcol_start = leftcol_width + 6
      end
    end
  end
end
