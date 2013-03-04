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
        end

        def opt(name, desc="", opts={})
          opts[:desc] ||= desc
          @options[name] ||= opts
          dependency(name, :on => opts[:depends_on]) if opts[:depends_on]
        end

        def dependency(option_name, opts = {})
          unless opts[:on]
            raise Escort::ClientError.new("Problem with syntax of dependency specification in #{@command_name} options block, #{option_name} missing ':on' condition")
          end
          @dependencies[option_name] ||= []
          [opts[:on]].flatten.each do |rule|
            case rule
            when Hash
              rule.each_pair do |rule_option, rule_option_value|
                if option_name == rule_option
                  raise Escort::ClientError.new("Problem with syntax of dependency specification in #{@command_name} options block, #{option_name} is set to depend on itself")
                end
              end
            else
              if option_name == rule
                raise Escort::ClientError.new("Problem with syntax of dependency specification in #{@command_name} options block, #{option_name} is set to depend on itself")
              end
            end
            @dependencies[option_name] << rule
          end
        end
      end
    end
  end
end
