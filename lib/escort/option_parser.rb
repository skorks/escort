module Escort
  class OptionParser
    attr_reader :setup

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
      options.merge!(parse_options(cli_options))
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
      stop_words = setup.command_names_for(context)
      parser = init_parser(stop_words)
      parser = add_setup_options_to(parser, context)
      parse_options_string(parser, cli_options)
    end

    def add_setup_options_to(parser, context = [])
      setup.options_for(context).each do |name, opts|
        parser.opt name, opts[:desc] || "", opts
      end
      parser
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
