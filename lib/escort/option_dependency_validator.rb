module Escort
  class OptionDependencyValidator
    class << self
      def for(parser)
        self.new(parser)
      end
    end

    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def validate(options, dependencies)
      dependencies.each_pair do |option_name, dependency_rules|
        ensure_dependencies_satisfied_for(option_name, dependency_rules, options)
      end
      options
    end

    private

    def option_exists?(option)
      parser.specs.keys.include?(option)
    end

    def ensure_dependencies_satisfied_for(option_name, dependency_rules, options)
      ensure_dependency_for_valid_option(option_name)
      dependency_rules.each do |rule|
        case rule
        when Hash
          handle_all_option_value_depndency_rules(option_name, rule, options)
        else
          ensure_option_depends_on_valid_option(rule)
          handle_possible_presence_dependency_issue(option_name, rule, options)
        end
      end
    end

    def handle_all_option_value_depndency_rules(option_name, rule, options)
      if option_was_specified?(option_name, options)
        rule.each_pair do |rule_option, rule_option_value|
          ensure_option_depends_on_valid_option(rule_option)
          handle_possible_option_value_dependency_issue(option_name, rule_option, rule_option_value, options)
        end
      end
    end

    def handle_possible_option_value_dependency_issue(option_name, rule_option, rule_option_value, options)
      unless options[rule_option] == rule_option_value
        raise Escort::UserError.new("Option dependency unsatisfied, '#{option_name}' depends on '#{rule_option}' having value '#{rule_option_value}', '#{option_name}' specified with value '#{options[option_name]}', but '#{rule_option}' is '#{options[rule_option]}'")
      end
    end

    def handle_possible_presence_dependency_issue(option_name, rule, options)
      if option_was_specified?(option_name, options) && option_was_unspecified?(rule, options)
        raise Escort::UserError.new("Option dependency unsatisfied, '#{option_name}' depends on '#{rule}', '#{option_name}' specified with value '#{options[option_name]}', but '#{rule}' is unspecified")
      end
    end

    def option_was_unspecified?(option_name, options)
      !option_was_specified?(option_name, options)
    end


    def option_was_specified?(option_name, options)
      !options[option_name].nil? && !(options[option_name] == []) && !(options[option_name] == false)
    end

    def ensure_dependency_for_valid_option(option_name)
      unless option_exists?(option_name)
        raise Escort::ClientError.new("Dependency specified for option '#{option_name}', but no such option was defined, perhaps you misspelled it")
      end
    end

    def ensure_option_depends_on_valid_option(rule)
      unless option_exists?(rule)
        raise Escort::ClientError.new("'#{option_name}' is set up to depend on '#{rule}', but '#{rule}' does not appear to be a valid option, perhaps it is a spelling error")
      end
    end
  end
end
