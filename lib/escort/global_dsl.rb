module Escort
  module GlobalDsl
    def config_file_name(file_name)
      @config_file_name = file_name
    end

    def no_arguments_valid
      @no_arguments_valid = true
    end

    def before(&block)
      @before_block = block
    end

    def on_error(&block)
      @error_block = block
    end

    def default(options_string)
      require 'shellwords' unless defined? Shellwords
      @default_options_string = Shellwords.shellwords(options_string)
    end
  end
end
