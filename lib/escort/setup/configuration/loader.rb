module Escort
  module Setup
    module Configuration
      class Loader
        attr_reader :setup, :auto_options

        def initialize(setup, auto_options)
          @setup = setup
          @auto_options = auto_options
        end

        def configuration
          if setup.has_config_file?
            Writer.new(config_path, Generator.new(setup).default_data).write if setup.config_file_autocreatable?
            Reader.new(config_path).read
          else
            Instance.blank
          end
        end

        def default_config_path
          @default_config_path ||= File.join(File.expand_path(ENV["HOME"]), config_filename)
        end

        private

        def config_filename
          @config_filename ||= setup.config_file
        end

        def config_path
          @config_path ||= (auto_options.non_default_config_path || locator.locate || default_config_path)
        end

        def locator
          Locator::Chaining.new(config_filename).
            add_locator(Locator::ExecutingScriptDirectory.new(config_filename)).
            add_locator(Locator::DescendingToHome.new(config_filename))
        end
      end
    end
  end
end
