module Escort
  module Setup
    module Dsl
      class ConfigFile
        def initialize(name, options = {})
          @name = name
          #TODO possibly raise error if autocreate is not a boolean
          @autocreate = options[:autocreate] || false
        end
      end
    end
  end
end
