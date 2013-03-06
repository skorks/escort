module Escort
  module Setup
    module Dsl
      class Options
        class << self
          def options(command_name, instance, &block)
            block.call(instance) if block_given?
          rescue => e
            raise Escort::ClientError.new("Problem with syntax of #{instance.instance_variable_get(:"@command_name")} options block", e)
          end
        end

        def initialize(command_name = :global)
          @command_name = command_name
          @options = {}
          @dependencies = {}
          @conflicts = {}
          @validations = {}
        end

        def opt(name, desc="", opts={})
          opts[:desc] ||= desc
          @options[name] ||= opts
          dependency(name, :on => opts[:depends_on]) if opts[:depends_on]
          conflict(*[name, opts[:conflicts_with]].flatten) if opts[:conflicts_with]
        end

        def validate(name, description, &block)
          @validations[name] ||= []
          @validations[name] << {:desc => description, :block => block}
        end

        def dependency(option_name, opts = {})
          ensure_dependency_specification_syntax(opts)
          @dependencies[option_name] ||= []
          rules_as_array(opts).each do |rule|
            ensure_no_self_dependency(option_name, rule)
            @dependencies[option_name] << rule
          end
        end

        def conflict(*opts)
          opts.each do |opt|
            conflicts_for_opt = opts.reject{|value| value == opt}
            @conflicts[opt] ||= []
            @conflicts[opt] += conflicts_for_opt
            @conflicts[opt].uniq!
          end
        end

        private
        def ensure_no_self_dependency(option_name, rule)
          case rule
          when Hash
            rule.each_pair do |rule_option, rule_option_value|
              handle_possible_self_dependency(option_name, rule_option)
            end
          else
            handle_possible_self_dependency(option_name, rule)
          end
        end

        def ensure_dependency_specification_syntax(opts)
          unless opts[:on]
            raise Escort::ClientError.new("Problem with syntax of dependency specification in #{@command_name} options block, #{option_name} missing ':on' condition")
          end
        end

        def rules_as_array(opts)
          [opts[:on]].flatten
        end

        def handle_possible_self_dependency(option_name, rule)
          if option_name == rule
            raise Escort::ClientError.new("Problem with syntax of dependency specification in #{@command_name} options block, #{option_name} is set to depend on itself")
          end
        end
      end
    end
  end
end
