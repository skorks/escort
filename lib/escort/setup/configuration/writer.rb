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
            current_path = File.expand_path(path)
            File.open(current_path,"w") do |f|
              f.puts JSON.pretty_generate(data)
            end
          end
          Instance.new(path, data)
        end

        def update
          raise Escort::InternalError.new("Not Implemented Yet")
        end
      end
    end
  end
end
