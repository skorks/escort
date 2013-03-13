describe "Escort basic app with no options defined", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    lambda do |app|
      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when called with empty option string" do
    let(:option_string) { "" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action_for_command(result, :global) }
  end

  context "when called with non-empty option string" do
    let(:option_string) { "hello" }
    it("exit code should be 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action_for_command(result, :global) }
  end

  context "gets --help option automatically" do
    let(:option_string) { "--help" }
    it("exit code should be 0") { expect{ subject }.to exit_with_code(0) }
  end

  context "gets --verbosity option automatically" do
    let(:option_string) { "--verbosity=DEBUG" }
    it("exit code should be 0") { expect{ subject }.to exit_with_code(0) }
  end

  context "gets --error-output-format option automatically" do
    let(:option_string) { "--error-output-format=advanced" }
    it("exit code should be 0") { expect{ subject }.to exit_with_code(0) }
  end
end
