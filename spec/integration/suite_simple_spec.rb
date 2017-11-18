describe "Escort suite app with one level of commands", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  let(:app_configuration) do
    lambda do |app|
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
      end

      app.command :command1, :aliases => [:c1]  do |command|
        command.options do |opts|
          opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
        end

        command.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when calling command with option and global option" do
    let(:option_string) { "-o hello command1 --option2 world" }

    before do
      begin
        subject
      rescue SystemExit => e
      end
    end
    it("should exit with code 0") { expect(subject).to exit_with_code(0) }
    it("should have the right command name") { result[:command_name].should == :command1 }
    it("should have have global option set") { result[:options][:global][:options][:option1].should == 'hello' }
    it("should have have command option set") { result[:command_options][:option2].should == 'world' }
  end

  context "when using command alias" do
    let(:option_string) { "-o hello c1 --option2 world" }
    it("should exit with code 0") { expect(subject).to exit_with_code(0) }
  end
end
