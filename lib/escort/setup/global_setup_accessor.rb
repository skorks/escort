module Escort
  class GlobalSetupAccessor
    def initialize(global_setup)
      @global_setup = global_setup
    end

    def arguments
      fetch_instance_variable_from_global_setup(:options_string)
    end

    def command_names
      fetch_instance_variable_from_global_setup(:command_names)
    end

    def command_blocks
      fetch_instance_variable_from_global_setup(:command_blocks)
    end

    def command_descriptions
      fetch_instance_variable_from_global_setup(:command_descriptions)
    end

    def action_block
      fetch_instance_variable_from_global_setup(:action_block)
    end

    def options_block
      fetch_instance_variable_from_global_setup(:options_block)
    end

    def options_string
      fetch_instance_variable_from_global_setup(:options_string)
    end

    private

    def fetch_instance_variable_from_global_setup(instance_variable)
      fetch_instance_variable_from(@global_setup, instance_variable)
    end

    def fetch_instance_variable_from(instance, instance_variable)
      instance_variable_symbol = :"@#{instance_variable.to_s}"
      instance.instance_variable_get(instance_variable_symbol)
    end
  end
end
