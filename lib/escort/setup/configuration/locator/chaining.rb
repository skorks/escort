module Escort
  module Setup
    module Configuration
      module Locator
        class Chaining < Base
          attr_reader :locators

          def initialize(filename, locators = [])
            super(filename)
            @locators = locators || []
          end

          def locate
            locators.each do |locator|
              filepath = locator.locate
              return filepath if filepath
            end
            nil
          end

          def add_locator(locator)
            @locators << locator
            self
          end
        end
      end
    end
  end
end
