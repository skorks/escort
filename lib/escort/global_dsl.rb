module Escort
  module GlobalDsl
    def before(&block)
      @before_block = block
    end

    def on_error(&block)
      @error_block = block
    end
  end
end
