module Escort
  module Setup
    module Dsl
      class Validations
        class << self
          def validations(command_name, instance, &block)
            block.call(instance) if block_given?
          rescue => e
            raise Escort::ClientError.new("Problem with syntax of #{instance.instance_variable_get(:"@command_name")} validations block", e)
          end
        end

        def initialize(command_name = :global)
          @command_name = command_name
          @validations = {}
        end

        def validate(name, description, &block)
          @validations[name] ||= []
          @validations[name] << {:desc => description, :block => block}
        end
      end
    end
  end
end
