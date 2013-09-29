#BasicNg::Application.command_map.build do |m|
  #m.default_action Escort::ExampleCommand
#end
module Escort
  class CommandMap
    def initialize
      @hash = {}
      @default_action = nil
    end

    def build(&block)
      dsl = self.class::DSL.new(self)
      yield(dsl) if block_given?
      self
    end

    def default_action=(command_class)
      @default_action = command_class
    end

    def default_action
      @default_action
    end

    class DSL
      attr_reader :command_map

      def initialize(command_map)
        @command_map = command_map
      end

      def default_action(command_class)
        command_map.default_action = command_class
      end
    end
  end
end
