module Escort
  module Formatter
    class Option
      attr_reader :name, :details

      def initialize(name, details)
        @name = name
        @details = details
      end

      def usage
        [long_string, short_string, type_string].select{|item| !item.empty?}.join(" ")
      end

      def description
        [base_description_string, description_default_string].select{|item| !item.empty?}.join(" ")
      end

      def conflicts
        #TODO implement this
      end

      def dependencies
        #TODO implement this
      end

      def validations
        #TODO implement this
      end

      private

      def base_description_string
        details[:desc] || details[:description] || ''
      end

      def description_default_string
        if details[:default]
          base_description_string =~ /\.$/ ? "(Default: #{default_string})" : "(default: #{default_string})"
        else
          ""
        end
      end

      def default_string
        case details[:default]
        when $stdout; "<stdout>"
        when $stdin; "<stdin>"
        when $stderr; "<stderr>"
        when Array
          details[:default].join(", ")
        else
          details[:default].to_s
        end
      end

      def short_string
        details[:short] && details[:short] != :none ? "-#{details[:short]}" : ""
      end

      def long_string
        if flag_with_default_true?
          "#{base_long_string}, --no-#{details[:long]}"
        else
          base_long_string
        end
      end

      def base_long_string
        "--#{details[:long]}"
      end

      def type_string
        case details[:type]
        when :flag; ""
        when :int; "<i>"
        when :ints; "<i+>"
        when :string; "<s>"
        when :strings; "<s+>"
        when :float; "<f>"
        when :floats; "<f+>"
        when :io; "<filename/uri>"
        when :ios; "<filename/uri+>"
        when :date; "<date>"
        when :dates; "<date+>"
        end
      end

      def flag_with_default_true?
        flag? && details[:default]
      end

      def flag?
        details[:type] == :flag
      end
    end
  end
end
