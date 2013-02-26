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

      #def valid_config_key?(key)
        #invalid_config_keys = [:help, :version, :config, :create_config, :create_default_config]
        #if invalid_config_keys.include?(key)
          #$stderr.puts "Invalid key (one of: #{invalid_config_keys.join(", ")}) found in config file, ignoring"
          #false
        #else
          #true
        #end
      #end

      def tokenize_option_string(option_string)
        Shellwords.shellwords(option_string)
      end
    end
  end
end
