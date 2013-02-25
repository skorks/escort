module Escort
  module Setup
    module Configuration
      class Loader
        attr_reader :setup

        def initialize(setup)
          @setup = setup
        end

        def configuration
          if setup.has_config_file?
            Writer.new(config_path, Generator.new(setup).default_data).write if setup.config_file_autocreatable?
            Reader.new(config_path).read
          end
        end

        private

        def config_filename
          @config_filename ||= setup.config_file
        end

        def config_path
          @config_path ||= Locator::DescendingToHome.new(config_filename).locate
        end

        def default_config_path
          @default_config_path ||= File.join(File.expand_path(ENV["HOME"]), config_filename)
        end
      end
    end
  end
end
