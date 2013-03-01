describe "Escort basic app that requires arguments", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    ->(app) do
      app.requires_arguments

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when called with no arguments" do
    let(:option_string) { "" }

    before do
      Readline.stub(:readline).and_return('1', nil)
    end

    it("action should receive ['1'] as arguments") { expect{subject}.to execute_action_with_arguments(result, ['1']) }
  end

  context "when called with one argument" do
    let(:option_string) { "1" }
    it("action should receive ['1'] as arguments") { expect{subject}.to execute_action_with_arguments(result, ['1']) }
  end

  context "when called with three arguments" do
    let(:option_string) { "1 2 3" }
    it("action should receive ['1', '2', '3'] as arguments") { expect{subject}.to execute_action_with_arguments(result, ['1', '2', '3']) }
  end
end
