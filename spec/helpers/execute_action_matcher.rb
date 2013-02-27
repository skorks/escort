RSpec::Matchers.define :execute_action do |command_name, result|
  match do |block|
    begin
      block.call
    rescue SystemExit => e
    end
    result.first == command_name
  end

  failure_message_for_should do |block|
    "'#{command_name}' action should have been executed as a result of block, but instead '#{result.first}' was executed"
  end

  failure_message_for_should_not do |block|
    "'#{command_name}' action should not have been executed as a result of block"
  end

  description do
    "'#{command_name}' action should have been executed as a result of block"
  end
end
