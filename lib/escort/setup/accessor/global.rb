module Escort
  module Setup
    module Accessor
      class Global
        include InstanceVariable

        def arguments
          fetch_instance_variable_from_setup(:options_string)
        end

        def command_names
          fetch_instance_variable_from_setup(:command_names)
        end

        def command_blocks
          fetch_instance_variable_from_setup(:command_blocks)
        end

        def command_descriptions
          fetch_instance_variable_from_setup(:command_descriptions)
        end

        def command_aliases
          fetch_instance_variable_from_setup(:command_aliases)
        end

        def action_block
          fetch_instance_variable_from_setup(:action_block)
        end

        def options_block
          fetch_instance_variable_from_setup(:options_block)
        end

        def options_string
          fetch_instance_variable_from_setup(:options_string)
        end

        def validations_block
          fetch_instance_variable_from_setup(:validations_block)
        end

        def valid_with_no_arguments
          fetch_instance_variable_from_setup(:valid_with_no_arguments)
        end

        def version
          fetch_instance_variable_from_setup(:version)
        end
      end
    end
  end
end
