module Escort
  module Setup
    module Configuration
      class Generator
        attr_reader :setup

        def initialize(setup)
          @setup = setup
        end

        def default_data
          config_hash = init_config_hash
          options([], config_hash[:global][:options]) #global options
          options_for_commands(setup.canonical_command_names_for([]), [], config_hash[:global][:commands])
          config_hash
        end

        private

        def options_for_commands(commands, context, options = {})
          commands.each do |command_name|
            command_name = command_name.to_sym
            options[command_name] = {}
            options[command_name][:options] = {}
            options[command_name][:commands] = {}
            current_context = context.dup
            current_context << command_name
            options(current_context, options[command_name][:options]) #command_options
            options_for_commands(setup.canonical_command_names_for(current_context), current_context, options[command_name][:commands])
          end
        end

        def init_config_hash
          {
            :global => {
              :options => {},
              :commands => {}
            },
            :user => {}
          }
        end

        def options(context = [], options = {})
          command_names = setup.command_names_for(context)
          parser = init_parser(command_names)
          parser = add_setup_options_to(parser, context)
          options.merge!(default_option_values(parser))
        end

        def init_parser(stop_words)
          Trollop::Parser.new.tap do |parser|
            parser.stop_on(stop_words)  # make sure we halt parsing if we see a command
          end
        end

        def add_setup_options_to(parser, context = [])
          setup.options_for(context).each do |name, opts|
            parser.opt name, opts[:desc] || "", opts
          end
          parser
        end

        def default_option_values(parser)
          hash = {}
          parser.specs.each_pair do |key, data|
            hash[key] = data[:default] || nil
          end
          hash
        end
      end
    end
  end
end
