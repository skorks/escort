module Escort
  class BlockExecutionCommand < Command
    attr_reader :block

    def initialize(options, arguments, &block)
      super(options, arguments)
      @block = block
    end

    def execute
      if block.arity == 0
        block.call
      elsif block.arity = 1
        block.call(options)
      else
        block.call(options, arguments)
      end
    end
  end
end
