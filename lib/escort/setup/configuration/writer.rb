require 'json'

module Escort
  module Setup
    module Configuration
      class Writer
        attr_reader :path, :data

        def initialize(path, data)
          @path = path
          @data = data
        end

        def write
          if path && !File.exists?(path)
            path = File.expand_path(path)
            File.open(path,"w") do |f|
              f.puts JSON.pretty_generate(data)
            end
          end
          Instance.new(path, data)
        end
      end
    end
  end
end
