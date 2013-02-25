module Escort
  module Setup
    module Configuration
      class Instance
        class << self
          def blank
            self.new(nil, {})
          end
        end

        attr_reader :data, :path

        def initialize(path, hash)
          @data = hash
          @path = path
        end

        def blank?
          data.empty?
        end
        alias empty? blank?

        def global
          data[:global] || {}
        end

        def user
          data[:user] || {}
        end
      end
    end
  end
end
