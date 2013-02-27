describe "Escort basic app with no options defined" do
  subject { Escort::App.create(option_string, &app_configuration) }
  let(:result) { [] }

  let(:app_configuration) do
    ->(app) do
      app.action do |options, arguments|
        result << :global
      end
    end
  end

  context "when called with empty option string" do
    let(:option_string) { "" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action(:global, result) }
  end

  context "when called with non-empty option string" do
    let(:option_string) { "hello" }
    it("exit code should be 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action(:global, result) }
  end
end
