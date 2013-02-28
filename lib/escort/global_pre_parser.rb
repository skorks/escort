module Escort
  class GlobalPreParser
    attr_reader :setup

    def initialize(setup)
      @setup = setup
    end

    def parse(cli_options)
      AutoOptions.new(parse_global_options(cli_options))
    end

    private

    def parse_global_options(cli_options, context = [])
      stop_words = setup.command_names_for(context).map(&:to_s)
      parser = init_parser(stop_words)
      parser = add_setup_options_to(parser, context)
      parser.version(setup.version)                                   #set the version if it was provided
      parser.help_formatter(Escort::Formatter::DefaultHelpFormatter.new(setup, context))
      parsed_options = parse_options_string(parser, cli_options)
    end

    def init_parser(stop_words)
      Trollop::Parser.new.tap do |parser|
        parser.stop_on(stop_words)
      end
    end

    def add_setup_options_to(parser, context = [])
      setup.options_for(context).each do |name, opts|
        parser.opt name, opts[:desc] || "", opts
      end
      parser
    end

    def parse_options_string(parser, cli_options)
      Trollop::with_standard_exception_handling(parser) do
        parser.parse(cli_options)
      end
    end
  end
end
