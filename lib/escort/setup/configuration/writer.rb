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
            save_to_file
            Instance.new(path, data)
          else
            Instance.blank
          end
        end

        def update
          current_data = {}
          if File.exists? path
            current_data = Reader.new(path).read.data
          end
          @data = Escort::Setup::Configuration::MergeTool.new(data, current_data).config_hash
          save_to_file
          Instance.new(path, data)
        end

        private

        def save_to_file
          current_path = File.expand_path(path)
          File.open(current_path,"w") do |f|
            f.puts JSON.pretty_generate(data)
          end
        end
      end
    end
  end
end
