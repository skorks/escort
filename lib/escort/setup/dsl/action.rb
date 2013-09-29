module Escort
  module Setup
    module Dsl
      class Action
        class << self
          def action(command_name, instance, command_class = nil, &block)
            #TODO warning when both the command name and the block are supplied
            if command_class
              instance.instance_variable_set(:"@block", create_command_block(command_class))
            end

            if block_given?
              instance.instance_variable_set(:"@block", block)
            end
          end

          def create_command_block(command_class)
            ->(options, arguments, extra_config = nil){
              command_class.new(options, arguments).execute
            }
          end
        end

        def initialize(command_name = :global)
          @command_name = command_name
        end
      end
    end
  end
end
