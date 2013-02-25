require 'pathname'

module Escort
  module Setup
    module Configuration
      module Locator
        class DescendingToHome < Base
          def locate
            return nil unless filename
            possible_configs = []
            Pathname.new(Dir.pwd).descend do |path|
              filepath = File.join(path, filename)
              if File.exists?(filepath)
                possible_configs << filepath
              end
            end
            possible_configs.empty? ? nil : possible_configs.last
          end
        end
      end
    end
  end
end
