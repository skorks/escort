module Escort
  module Setup
    module Dsl
      class Options
        class << self
          def options(instance, &block)
            block.call(instance) if block_given?
          rescue => e
            raise Escort::ClientError.new("Problem with syntax of #{instance.instance_variable_get(:"@command_name")} options block", e)
          end
        end

        def initialize(command_name = :global)
          @command_name = command_name
          @options = {}
        end

        def opt(name, desc="", opts={})
          opts[:desc] ||= desc
          @options[name] ||= opts
        end
      end
    end
  end
end
