module Escort
  module Setup
    module Configuration
      module Locator
        class Base
          attr_reader :filename

          def initialize(filename)
            @filename = filename
          end

          def locate
            raise "Must be defined in child class"
          end
        end
      end
    end
  end
end
