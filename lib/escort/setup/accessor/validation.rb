module Escort
  module Setup
    module Accessor
      class Validation
        include InstanceVariable

        def validations
          fetch_instance_variable_from_setup(:validations)
        end
      end
    end
  end
end
