#BasicNg::Application.command_map.build do |m|
  #m.default_action Escort::ExampleCommand
#end
module Escort
  class CommandMap
    DEFAULT_KEY = '__default__'

    def initialize
      @commands = {}
    end

    def build(&block)
      dsl = self.class::DSL.new(self)
      yield(dsl) if block_given?
      self
    end

    def has_command_for?(key)
      @commands[key] != nil
    end

    def command_for(key)
      @commands[key]
    end

    def set_command(key, value)
      @commands[key] = value
    end

    class DSL
      attr_reader :command_map

      def initialize(command_map)
        @command_map = command_map
      end

      def default_command(command_class = nil, &block)
        if block_given?
          command_map.set_command(DEFAULT_KEY, block)
        else
          command_map.set_command(DEFAULT_KEY, command_class)
        end
      end
    end
  end
end
