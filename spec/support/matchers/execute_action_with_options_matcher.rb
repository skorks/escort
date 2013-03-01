RSpec::Matchers.define :execute_action_with_options do |result, expected_options|
  match do |block|
    begin
      block.call
    rescue SystemExit => e
    end
    successful_match?(result, expected_options)
  end

  def successful_match?(result, expected_options)
    options = result[:command_options]
    expected_options.keys.each do |key|
      return false unless options[key] == expected_options[key]
    end
    true
  end

  failure_message_for_should do |block|
    "'#{expected_options}' should have been passed to action, but we got '#{result[:command_options]}'"
  end

  failure_message_for_should_not do |block|
    "'#{expected_options}' should not have been passed to action"
  end

  description do
    "'#{expected_options}' should have been passed to action"
  end
end
