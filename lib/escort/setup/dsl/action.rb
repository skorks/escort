module Escort
  module Setup
    module Dsl
      class Action
        def initialize(&block)
          @block = block
        end

        #def execute(options, arguments)
          #@block.call(options, arguments)
        #end
      end
    end
  end
end
