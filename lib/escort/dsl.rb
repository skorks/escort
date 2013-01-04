module Escort
  module Dsl
    attr_reader :command_names

    def options(&block)
      @options_block = block
    end

    def command(name, &block)
      @command_names ||= []
      @command_names << name.to_s
      @command_blocks ||= {}
      @command_blocks[name.to_s] = block
    end

    def action(&block)
      @action_block = block
    end
  end
end
