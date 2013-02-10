module Escort
  module Setup
    module Dsl
      class Action
        def initialize(&block)
          @block = block
        end
      end
    end
  end
end
