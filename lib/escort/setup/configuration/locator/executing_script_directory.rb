module Escort
  module Setup
    module Configuration
      module Locator
        class ExecutingScriptDirectory < Base
          def locate
            location_directory = File.dirname($0)
            filepath = File.expand_path(File.join(location_directory, filename))
            File.exists?(filepath) ? filepath : nil
          end
        end
      end
    end
  end
end
