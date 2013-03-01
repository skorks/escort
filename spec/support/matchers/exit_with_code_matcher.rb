RSpec::Matchers.define :exit_with_code do |expected_code|
  actual = nil
  match do |block|
    begin
      block.call
    rescue SystemExit => e
      actual = e.status
    end
    actual && actual == expected_code
  end
  failure_message_for_should do |block|
    "expected block to call exit(#{expected_code}) but exit #{actual.nil? ? "not called" : "(#{actual}) was called"}"
  end
  failure_message_for_should_not do |block|
    "expected block not to call exit(#{expected_code})"
  end
  description do
    "expect block to call exit(#{expected_code})"
  end
end
