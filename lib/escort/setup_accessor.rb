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

    def conflicting_options_for(context = [])
      with_context(context) do |current_context|
        conflicts_hash_for(current_context)
      end
    end

    def validations_for(context = [])
      with_context(context) do |current_context|
        validations_hash_from(current_context)
      end
    end

    def dependencies_for(context = [])
      with_context(context) do |current_context|
        dependencies_hash_from(current_context)
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

    def version
      version_string = fetch_instance_variable_from(global_instance, :version)
    end

    def summary_for(context = [])
      with_context(context) do |current_context|
        fetch_instance_variable_from(current_context, :summary)
      end
    end

    def description_for(context = [])
      with_context(context) do |current_context|
        fetch_instance_variable_from(current_context, :description)
      end
    end

    def command_description_for(command_name, context = [])
      with_context(context) do |current_context|
        commands = fetch_instance_variable_from(current_context, :commands)
        fetch_instance_variable_from(commands[command_name], :description)
      end
    end

    def command_summary_for(command_name, context = [])
      with_context(context) do |current_context|
        commands = fetch_instance_variable_from(current_context, :commands)
        fetch_instance_variable_from(commands[command_name], :summary)
      end
    end

    def command_aliases_for(command_name, context = [])
      with_context(context) do |current_context|
        commands = fetch_instance_variable_from(current_context, :commands)
        description = fetch_instance_variable_from(commands[command_name], :aliases)
      end
    end

    def add_global_option(name, desc, options = {})
      with_context([]) do |current_context|
        options_object = options_object_from(current_context)
        options_object.opt name, desc, options
      end
    end

    def add_global_command(name, options = {}, &block)
      global_instance.command(name, options, &block)
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
      ensure_context_object(context_object, {}) do
        options_object = options_object_from(context_object)
        fetch_instance_variable_from(options_object, :options)
      end
    end

    def options_object_from(context_object)
      ensure_context_object(context_object, nil) do
        fetch_instance_variable_from(context_object, :options)
      end
    end

    def conflicts_hash_for(context_object)
      ensure_context_object(context_object, {}) do
        options_object = options_object_from(context_object)
        fetch_instance_variable_from(options_object, :conflicts)
      end
    end

    def validations_hash_from(context_object)
      ensure_context_object(context_object, {}) do
        validations_object = fetch_instance_variable_from(context_object, :options)
        fetch_instance_variable_from(validations_object, :validations)
      end
    end

    def dependencies_hash_from(context_object)
      ensure_context_object(context_object, {}) do
        options_object = options_object_from(context_object)
        fetch_instance_variable_from(options_object, :dependencies)
      end
    end

    def fetch_instance_variable_from_setup(instance_variable)
      fetch_instance_variable_from(global_instance, instance_variable)
    end

    def fetch_instance_variable_from(instance, instance_variable)
      instance_variable_symbol = :"@#{instance_variable.to_s}"
      instance.instance_variable_get(instance_variable_symbol)
    end

    def ensure_context_object(context_object, default_value, &block)
      context_object ? block.call : default_value
    end
  end
end
