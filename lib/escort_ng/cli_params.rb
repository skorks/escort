module Escort
  class CliParams
    attr_reader :option_list

    def initialize(option_list)
      @option_list = option_list
      @mutable_option_list = option_list.dup
    end

    def command
      nil
    end

    def options(option_registry)
      parser = Trollop::Parser.new do
        option_registry.each do |name, opts|
          opt name, opts[:desc] || "", opts.dup
        end
      end
      Trollop::with_standard_exception_handling(parser) do
        parser.parse(mutable_option_list)
      end
    end

    def arguments
      nil
    end

    private

    def mutable_option_list
      @mutable_option_list
    end
  end
end
