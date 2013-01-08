module Escort
  module Dsl
    attr_reader :command_names

    def options(&block)
      @options_block = block
    end

    def command(name, options = {}, &block)
      aliases = [options[:aliases] || []].flatten
      description = options[:description]
      @command_names ||= []
      @command_blocks ||= {}
      @command_descriptions ||= {}
      add_data_for_command(name.to_s, description, &block)
      aliases.each {|name_alias| add_data_for_command(name_alias.to_s, description, &block) }
    end

    def action(&block)
      @action_block = block
    end

    def validations(&block)
      @validations_block = block
    end

    private

    def add_data_for_command(name, description, &block)
      @command_names << name
      @command_descriptions[name] = description
      @command_blocks[name] = block
    end
  end
end
