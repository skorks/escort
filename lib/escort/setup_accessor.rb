module Escort
  class SetupAccessor
    attr_reader :global_instance

    def initialize(global_instance)
      @global_instance = global_instance
    end

    def options_for(context = [])
      with_context(context) do |current_context|
        options_hash_from(current_context)
      end
    end

    def command_names_for(context = [])
      with_context(context) do |current_context|
        command_names_from(current_context)
      end
    end

    def action_for(context = [])
      with_context(context) do |current_context|
        action_block_from(current_context)
      end
    end

    private

    def with_context(context = [], &block)
      context = [] if context.nil? || context.empty?
      context = [context] unless context.kind_of?(Array)
      current_context = global_instance
      context.each do |command_name|
        commands = fetch_instance_variable_from(current_context, :commands)
        current_context = commands[command_name.to_sym]
      end
      block.call(current_context)
    end

    def action_block_from(context_object)
      action_object = fetch_instance_variable_from(context_object, :action)
      block = fetch_instance_variable_from(action_object, :block)
    end

    def command_names_from(context_object)
      commands = fetch_instance_variable_from(context_object, :commands)
      commands.keys
    end

    def options_hash_from(context_object)
      options_object = fetch_instance_variable_from(context_object, :options)
      fetch_instance_variable_from(options_object, :options)
    end

    def fetch_instance_variable_from_setup(instance_variable)
      fetch_instance_variable_from(global_instance, instance_variable)
    end

    def fetch_instance_variable_from(instance, instance_variable)
      instance_variable_symbol = :"@#{instance_variable.to_s}"
      instance.instance_variable_get(instance_variable_symbol)
    end
  end
end
