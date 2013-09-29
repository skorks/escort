#MyApplication::Application.option_registry.build do |r|
  #r.option :flag1, desc: "Flag 1", short: 'f', long: 'flag1', type: :boolean, default: true
  #r.option :flag2, desc: "Flag 2", short: :none, long: 'flag2', type: :boolean
#end
module Escort
  class OptionRegistry
    def initialize
      @hash = {}
    end

    def build(&block)
      dsl = self.class::DSL.new(self)
      yield(dsl) if block_given?
      self
    end

    def add_option(identifier, data)
      @hash[identifier] = data
    end

    class DSL
      attr_reader :option_registry

      def initialize(option_registry)
        @option_registry = option_registry
      end

      def option(identifier, data = {})
        option_registry.add_option(identifier, data)
      end
    end
  end
end
