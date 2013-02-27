RSpec::Matchers.define :give_option_to_action_with_value do |option_name, expected_value, result|
  match do |block|
    begin
      block.call
    rescue SystemExit => e
    end
    options = result[1] || {}
    options.keys.include?(option_name) && options[option_name] == expected_value
  end

  failure_message_for_should do |block|
    "'#{option_name}' should have been passed to action with value '#{expected_value}', but instead we got '#{(result[1] || {})[option_name]}'"
  end

  failure_message_for_should_not do |block|
    "'#{option_name}' should not have been passed to action with value '#{expected_value}'"
  end

  description do
    "'#{option_name}' should have been passed to action with value '#{expected_value}'"
  end
end
