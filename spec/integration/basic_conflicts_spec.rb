describe "Escort basic app with conflicting options", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    lambda do |app|
      app.options do |opts|
        opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
        opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean

        opts.conflict :flag1, :flag2
      end

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when conflicting options supplied" do
    let(:option_string) { "--flag1 --flag2" }
    it("should exit with code 2 or 3") { expect{ subject }.to exit_with_code(2, 3) }
  end

  context "when no conflicting options supplied" do
    let(:option_string) { "--flag1" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
  end
end
