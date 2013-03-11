module Escort
  module Setup
    module Configuration
      module Locator
        class SpecifiedDirectory < Base
          attr_reader :location_directory

          def initialize(filename, location_directory)
            super(filename)
            @location_directory = location_directory
          end

          def locate
            filepath = File.expand_path(File.join(location_directory, filename))
            File.exists?(filepath) ? filepath : nil
          end
        end
      end
    end
  end
end
