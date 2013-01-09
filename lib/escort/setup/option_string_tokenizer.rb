require 'shellwords'

module Escort
  module Setup
    class OptionStringTokenizer
      class << self
        def tokenize(options_string)
          Shellwords.shellwords(options_string)
        end
      end
    end
  end
end
