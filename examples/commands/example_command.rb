module Escort
  class ExampleCommand < ::Escort::ActionCommand::Base
    def execute
      Escort::Logger.output.puts "Command: #{command_name}"
      Escort::Logger.output.puts "Options: #{options}"
      Escort::Logger.output.puts "Command options: #{command_options}"
      Escort::Logger.output.puts "Arguments: #{arguments}"
      if config
        Escort::Logger.output.puts "User config: #{config}"
      end
    end
  end
end
