describe "Escort basic app with version, description, and summary", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    lambda do |app|
      app.version "0.1.1"
      app.summary "Sum1"
      app.description "Desc1"

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when called" do
    let(:option_string) { "" }

    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
  end
end
