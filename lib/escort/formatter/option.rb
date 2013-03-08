module Escort
  module Formatter
    class Option
      attr_reader :name, :details, :setup, :context

      def initialize(name, details, setup, context)
        @name = name.to_sym
        @details = details
        @setup = setup
        @context = context
      end

      def usage
        [long_string, short_string, type_string].select{|item| !item.empty?}.join(" ")
      end

      def description
        [base_description_string, description_default_string].select{|item| !item.empty?}.join(" ")
      end

      def has_conflicts?
        !conflicts_list.empty?
      end

      def conflicts
        has_conflicts? ? "conflicts with: #{conflicts_list.map{|option| "--#{option}"}.join(', ')}" : ''
      end

      def has_dependencies?
        !dependencies_list.empty?
      end

      def dependencies
        has_dependencies? ? "depends on: #{format_dependency_list(dependencies_list).join(', ')}" : ''
      end

      def has_validations?
        !validations_list.empty?
      end

      def validations
        has_validations? ? validation_messages : []
      end

      private
      def validation_messages
        validations_list.map{|validation| validation[:desc]}
      end

      def validations_list
        setup.validations_for(context)[name] || []
      end

      def format_dependency_list(dependency_list)
        dependencies_list.map do |option|
          case option
          when Hash
            option.inject([]){|acc, (key, value)| acc << "--#{key}=#{value}"}.join(', ')
          else
            "--#{option}"
          end
        end
      end

      def dependencies_list
        setup.dependencies_for(context)[name] || []
      end

      def conflicts_list
        setup.conflicting_options_for(context)[name] || []
      end

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
