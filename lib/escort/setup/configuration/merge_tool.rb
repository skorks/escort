module Escort
  module Setup
    module Configuration
      class MergeTool
        def initialize(new_config_hash, old_config_hash)
          @new_config_hash = new_config_hash
          @old_config_hash = old_config_hash
        end

        def config_hash
          merge_config(@new_config_hash, @old_config_hash)
        end

        private

        def merge_config(new_hash, old_hash)
          new_hash.keys.each do |key|
            new_config_value = new_hash[key]
            old_config_value = old_hash[key]

            if new_config_value.kind_of?(Hash) && old_config_value.kind_of?(Hash)
              new_hash[key] = merge_config(new_config_value, old_config_value)
            elsif old_config_value.nil?
              new_hash[key] = new_config_value
            else
              new_hash[key] = old_config_value
            end

            if key == :user
              new_hash[key] = old_config_value
            end
          end
          new_hash
        end
      end
    end
  end
end
