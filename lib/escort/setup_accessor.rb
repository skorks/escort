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

    def canonical_command_names_for(context = [])
      with_context(context) do |current_context|
        canonical_command_names_from(current_context)
      end
    end

    def action_for(context = [])
      with_context(context) do |current_context|
        action_block_from(current_context)
      end
    end

    def arguments_required_for(context = [])
      with_context(context) do |current_context|
        context_requires_arguments(current_context)
      end
    end

    def has_config_file?
      config_file_object != nil
    end

    def config_file_autocreatable?
      autocreatable = fetch_instance_variable_from(config_file_object, :autocreate)
    end

    def config_file
      name = fetch_instance_variable_from(config_file_object, :name)
    end

    private

    def config_file_object
      config_file = fetch_instance_variable_from(global_instance, :config_file)
    end

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

    def context_requires_arguments(context_object)
      requires_arguments = fetch_instance_variable_from(context_object, :requires_arguments)
    end

    def action_block_from(context_object)
      action_object = fetch_instance_variable_from(context_object, :action)
      block = fetch_instance_variable_from(action_object, :block)
      #TODO make sure that if there is no block we exit with a client error
    end

    def command_names_from(context_object)
      commands = fetch_instance_variable_from(context_object, :commands)
      commands.keys
      #TODO make sure there can be no errors here and at worst it is an empty array
    end

    def canonical_command_names_from(context_object)
      commands = fetch_instance_variable_from(context_object, :commands)
      commands.select do |key, command|
        aliases = fetch_instance_variable_from(command, :aliases)
        !aliases.include?(key)
      end.keys
      #TODO make sure there can be no errors here and at worst it is an empty array
    end

    def options_hash_from(context_object)
      options_object = fetch_instance_variable_from(context_object, :options)
      fetch_instance_variable_from(options_object, :options)
      #TODO make sure there can be no errors here and at worst it is an empty hash
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
