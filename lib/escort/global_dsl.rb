module Escort
  module GlobalDsl
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
