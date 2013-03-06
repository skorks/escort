module Escort
  class OptionParser
    attr_reader :setup, :configuration

    def initialize(configuration, setup)
      @configuration = configuration
      @setup = setup
    end

    def parse(cli_options)
      options = init_invoked_options_hash
      parse_global_options(cli_options, options[:global][:options])
      parse_command_options(cli_options, [], options[:global][:commands])

      [options, arguments_from(cli_options)]
    end

    private

    def init_invoked_options_hash
      {
        :global => {
          :options => {},
          :commands => {}
        }
      }
    end

    def parse_global_options(cli_options, options)
      context = []
      options.merge!(parse_options(cli_options, context))
    end

    def parse_command_options(cli_options, context, options)
      unless cli_option_is_a_command?(cli_options, context)
        options
      else
        command = command_name_from(cli_options)
        context << command
        current_options = parse_options(cli_options, context)
        options[command] = {}
        options[command][:options] = current_options
        options[command][:commands] = {}
        parse_command_options(cli_options, context, options[command][:commands])
      end
    end

    def parse_options(cli_options, context = [])
      stop_words = setup.command_names_for(context).map(&:to_s)
      parser = init_parser(stop_words)
      parser = add_setup_options_to(parser, context)
      parser = add_option_conflicts_to(parser, context)
      parser = default_option_values_from_config_for(parser, context)
      parser.version(setup.version)                                   #set the version if it was provided
      parser.help_formatter(Escort::Formatter::DefaultHelpFormatter.new(setup, context))
      parsed_options = parse_options_string(parser, cli_options)
      Escort::OptionDependencyValidator.for(parser).validate(parsed_options, setup.dependencies_for(context))
      Escort::Validator.for(parser).validate(parsed_options, setup.validations_for(context))
    end

    def add_setup_options_to(parser, context = [])
      setup.options_for(context).each do |name, opts|
        parser.opt name, opts[:desc] || "", opts.dup #have to make sure to dup here, otherwise opts might get stuff added to it and it
                                                     #may cause problems later, e.g. adds default value and when parsed again trollop barfs
      end
      parser
    end

    def add_option_conflicts_to(parser, context = [])
      conflicting_options_for_context = setup.conflicting_options_for(context)
      conflicting_options_for_context.keys.each do |option_name|
        conflict_list = [option_name] + conflicting_options_for_context[option_name]
        conflict_list.each do |option|
          raise Escort::ClientError.new("Conflict defined with option '#{option}', but this option does not exist, perhaps it is a spelling error.") unless option_exists?(parser, option)
        end
        parser.conflicts *conflict_list
      end
      parser
    end

    def option_exists?(parser, option)
      parser.specs.keys.include?(option)
    end

    def default_option_values_from_config_for(parser, context)
      unless configuration.empty?
        parser.specs.each do |sym, opts|
          if config_has_value_for_context?(sym, context)
            default = config_value_for_context(sym, context)
            opts[:default] = default
            if opts[:multi] && default.nil?
              opts[:default] = []  # multi arguments default to [], not nil
            elsif opts[:multi] && !default.kind_of?(Array)
              opts[:default] = [default]
            else
              opts[:default] = default
            end
          end
        end
      end
      parser
    end

    def config_has_value_for_context?(option, context)
      relevant_config_hash = config_hash_for_context(context)
      relevant_config_hash[:options].include?(option)
    end

    def config_value_for_context(option, context)
      relevant_config_hash = config_hash_for_context(context)
      relevant_config_hash[:options][option]
    end

    def config_hash_for_context(context)
      relevant_config_hash = configuration.global
      context.each do |command_name|
        command_name = command_name.to_sym
        relevant_config_hash = relevant_config_hash[:commands][command_name]
        relevant_config_hash = ensure_config_hash_has_options_and_commands(relevant_config_hash)
      end
      relevant_config_hash
    end

    def ensure_config_hash_has_options_and_commands(relevant_config_hash)
      relevant_config_hash ||= {}
      relevant_config_hash[:commands] ||= {}
      relevant_config_hash[:options] ||= {}
      relevant_config_hash
    end

    def cli_option_is_a_command?(cli_options, context)
      cli_options.size > 0 && setup.command_names_for(context).include?(cli_options[0].to_sym)
    end

    def init_parser(stop_words)
      Trollop::Parser.new.tap do |parser|
        parser.stop_on(stop_words)  # make sure we halt parsing if we see a command
      end
    end

    def parse_options_string(parser, cli_options)
      Trollop::with_standard_exception_handling(parser) do
        parser.parse(cli_options)
      end
    end

    def command_name_from(cli_options)
      cli_options.shift.to_sym
    end

    def arguments_from(cli_options)
      cli_options
    end
  end
end
