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
          hash.empty?
        end
      end
    end
  end
end
