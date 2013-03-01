RSpec::Matchers.define :execute_action_with_arguments do |result, expected_arguments|
  match do |block|
    begin
      block.call
    rescue SystemExit => e
    end
    successful_match?(result, expected_arguments)
  end

  def successful_match?(result, expected_arguments)
    result[:arguments] == expected_arguments
  end

  failure_message_for_should do |block|
    "'#{expected_arguments}' should have been passed to action, but we got '#{result[:arguments]}'"
  end

  failure_message_for_should_not do |block|
    "'#{expected_arguments}' should not have been passed to action"
  end

  description do
    "'#{expected_arguments}' should have been passed to action"
  end
end
