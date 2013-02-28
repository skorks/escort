module Escort
  module Setup
    module Dsl
      class Action
        class << self
          def action(command_name, instance, &block)
            instance.instance_variable_set(:"@block", block)
          end
        end

        def initialize(command_name = :global)
          @command_name = command_name
        end
      end
    end
  end
end
