module Escort
  module Setup
    module Dsl
      class Global < Command
        def initialize(&block)
          reset(:global)
          block.call(self)
        rescue => e
          raise Escort::ClientError.new("Problem with syntax of global configuration", e)
        end

        def config_file(name, options = {})
          @config_file = ConfigFile.new(name, options)
        end

        def version(version)
          @version = version
        end

        private

        def custom_reset
          @version = nil
          @config_file  = nil
        end
      end
    end
  end
end
