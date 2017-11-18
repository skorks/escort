describe "Escort basic app with multi option", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    lambda do |app|
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :multi => true
      end

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when called with empty option string" do
    let(:option_string) { "" }
    it("option1 should be an empty array") { expect(subject).to execute_action_with_options(result, :option1 => []) }
  end

  context "when called with option1 specified once" do
    let(:option_string) { "-o blah" }
    it("option1 have the value ['blah'] in action") { expect(subject).to execute_action_with_options(result, :option1 => ['blah']) }
  end

  context "when called with option1 specified 3 times" do
    let(:option_string) { "-o blah --option1=blah2 -o blah3" }
    it("option1 have the value ['blah', 'blah2', 'blah3'] in action") { expect(subject).to execute_action_with_options(result, :option1 => ['blah', 'blah2', 'blah3']) }
  end
end
