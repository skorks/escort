module Escort
  module Setup
    module Accessor
      module InstanceVariable
        def initialize(setup)
          @setup = setup
        end

        private

        def fetch_instance_variable_from_setup(instance_variable)
          fetch_instance_variable_from(@setup, instance_variable)
        end

        def fetch_instance_variable_from(instance, instance_variable)
          instance_variable_symbol = :"@#{instance_variable.to_s}"
          instance.instance_variable_get(instance_variable_symbol)
        end
      end
    end
  end
end
