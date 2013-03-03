#TODO don't need a separate class for this possibly or should be refactored at any rate
module Escort
  module Formatter
    module Common
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
    end
  end
end
