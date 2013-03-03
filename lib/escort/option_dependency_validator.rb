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
        unless option_exists?(option_name)
          raise Escort::ClientError.new("Dependency specified for option '#{option_name}', but no such option was defined, perhaps you misspelled it")
        end
        dependency_rules.each do |rule|
          case rule
          when Hash
            if !options[option_name].nil? && !(options[option_name] == []) && !(options[option_name] == false)
              rule.each_pair do |rule_option, rule_option_value|
                unless option_exists?(rule_option)
                  raise Escort::ClientError.new("'#{option_name}' is set up to depend on '#{rule_option}', but '#{rule_option}' does not appear to be a valid option, perhaps it is a spelling error")
                end
                unless options[rule_option] == rule_option_value
                  raise Escort::UserError.new("Option dependency unsatisfied, '#{option_name}' depends on '#{rule_option}' having value '#{rule_option_value}', '#{option_name}' specified with value '#{options[option_name]}', but '#{rule_option}' is '#{options[rule_option]}'")
                end
              end
            end
          else
            unless option_exists?(rule)
              raise Escort::ClientError.new("'#{option_name}' is set up to depend on '#{rule}', but '#{rule}' does not appear to be a valid option, perhaps it is a spelling error")
            end
            if !options[option_name].nil? && !(options[option_name] == []) && !(options[option_name] == false)
              if options[rule].nil? || options[rule] == false || options[rule] == []
                raise Escort::UserError.new("Option dependency unsatisfied, '#{option_name}' depends on '#{rule}', '#{option_name}' specified with value '#{options[option_name]}', but '#{rule}' is unspecified")
              end
            end
          end
        end
      end
      options
    end

    private

    def option_exists?(option)
      parser.specs.keys.include?(option)
    end
  end
end
