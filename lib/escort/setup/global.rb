module Escort
  module Setup
    class Global
      include Common

      def initialize(options_string, &block)
        reset
        @options_string = options_string || ARGV.dup
        block.call(self)
        setup_options_string(options_string)
      rescue => e
        #TODO instead of printing to stderr do some logging e.g. Logger.error
        #this is a client usage of library error so returning with exit code 2
        #TODO we can perhaps create a method missing so that if we end up in there we know the syntax is screwed
        STDERR.puts "Problem with syntax of app global configuration"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end

      def valid_with_no_arguments
        @valid_with_no_arguments = true
      end

      def config_file(file_name, options = {})
        options = {:autocreate => false}.merge!(options)
        @config_file = {:default_file_name => file_name, :autocreate => options[:autocreate]}
      end

      def version(version)
        @version = version
      end

      def summary(summary)
        @summary = summary
      end

      def description(description)
        @description = description
      end

      def default(options_string)
        @default_options_string = OptionStringTokenizer.tokenize(options_string)
      rescue => e
        #TODO instead of printing to stderr do some logging e.g. Logger.error
        STDERR.puts "The default command is invalid: #{options_string}"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end

      def command(name, options = {}, &block)
        aliases = [options[:aliases] || []].flatten
        description = options[:description]
        add_data_for_command(name.to_s, aliases, description, &block)
        aliases.each {|name_alias| add_data_for_command(name_alias.to_s, nil, description, &block) }
      end

      private

      def reset
        @version = nil
        @summary = nil
        @description = nil
        @valid_with_no_arguments = false
        @config_file = nil
        @default_options_string = ['--help']
        @options_string = []
        @command_names ||= []
        @command_blocks ||= {}
        @command_descriptions ||= {}
        @command_aliases ||= {}
        common_reset
      end

      def setup_options_string(options_string)
        @options_string = options_string || ARGV.dup
        if @options_string.size == 0
          @options_string = @default_options_string
        end
      end

      def add_data_for_command(name, aliases, description, &block)
        @command_names << name
        @command_descriptions[name] = description
        @command_blocks[name] = block
        @command_aliases[name] = aliases if aliases
      end
    end
  end
end
