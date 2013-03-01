RSpec::Matchers.define :execute_action_for_command do |result, command_name|
  match do |block|
    begin
      block.call
    rescue SystemExit => e
    end
    result[:command_name] == command_name
  end

  failure_message_for_should do |block|
    "'#{command_name}' action should have been executed as a result of block, but instead '#{result[:command_name]}' was executed"
  end

  failure_message_for_should_not do |block|
    "'#{command_name}' action should not have been executed as a result of block"
  end

  description do
    "'#{command_name}' action should have been executed as a result of block"
  end
end
