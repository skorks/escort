module Escort
  module Setup
    module Configuration
      class Reader
        attr_reader :path

        def initialize(path)
          @path = path
        end

        def read
          data = {}
          data = load_config_at_path if path
          Instance.new(path, data)
        end

        private

        def load_config_at_path
          data = {}
          begin
            json = File.read(path)
            hash = JSON.parse(json)
            data = Escort::Utils.symbolize_keys(hash)
          rescue => e
            error_logger.warn { "Found config at #{path}, but failed to load it, perhaps your JSON syntax is invalid. Attempting to continue without..." }
            error_logger.error(e)
          end
          data
        end
      end
    end
  end
end
