module Escort
  module Setup
    module Accessor
      class Command
        include InstanceVariable

        def command_name
          fetch_instance_variable_from_setup(:command_name)
        end

        def command_description
          fetch_instance_variable_from_setup(:command_description)
        end

        def action_block
          fetch_instance_variable_from_setup(:action_block)
        end

        def options_block
          fetch_instance_variable_from_setup(:options_block)
        end

        def validations_block
          fetch_instance_variable_from_setup(:validations_block)
        end
      end
    end
  end
end
