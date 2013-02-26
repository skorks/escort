require 'shellwords'

module Escort
  class Utils
    class << self
      def symbolize_keys(hash)
        hash.inject({}) do |result, (key, value)|
          new_key = (key.kind_of?(String) ? key.to_sym : key)
          new_value = (value.kind_of?(Hash) ? symbolize_keys(value) : value)
          result[new_key] = new_value
          result
        end
      end

      def tokenize_option_string(option_string)
        Shellwords.shellwords(option_string)
      end
    end
  end
end
