describe "Escort basic app with config file defined", :integration => true do
  include FakeFS::SpecHelpers

  subject { Escort::App.create(option_string, &app_configuration) }

  let(:path) {File.join(File.expand_path('~'), '.test_apprc')}
  let(:app_configuration) do
    lambda do |app|
      app.config_file ".test_apprc", :autocreate => autocreate

      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
      end

      app.action do |options, arguments|
        Escort::IntegrationTestCommand.new(options, arguments).execute(result)
      end
    end
  end

  context "when config file is autocreatable" do
    context "and config file does not yet exist" do
      before do
        begin
          subject
        rescue SystemExit => e
        end
      end
      let(:autocreate) {true}
      let(:option_string) { "" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      it("should have created a config file in default location") { File.should exist path  }
    end

    context "and config file already exists" do
      before do
        FileUtils.mkdir_p(File.dirname path)
        File.open(path, 'w') {|f| f.write(JSON.pretty_generate({:global => {:commands => {}, :options => {:option1 => 'hello'}}, :user => {}})) }

        begin
          subject
        rescue SystemExit => e
        end
      end
      let(:autocreate) {true}
      let(:option_string) { "" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      it("should have picked up the existing config file") { result[:command_options][:option1].should == 'hello' }
    end
  end

  context "when config file is not autocreatable" do
    context "and config file already exists" do
      let(:autocreate) {false}
      let(:option_string) { "" }
      before do
        FileUtils.mkdir_p(File.dirname path)
        File.open(path, 'w') {|f| f.write(JSON.pretty_generate({:global => {:commands => {}, :options => {:option1 => 'hello'}}, :user => {}})) }

        begin
          subject
        rescue SystemExit => e
        end
      end
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      it("should have picked up the existing config file") { result[:command_options][:option1].should == 'hello' }
    end

    context "and config file does not yet exist" do
      let(:autocreate) {false}
      let(:option_string) { "" }
      before do
        begin
          subject
        rescue SystemExit => e
        end
      end
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      it("should not have created a config file in default location") { File.should_not exist path  }
    end
  end

  context "when config file specified" do
    let(:autocreate) {false}

    before do
      FileUtils.mkdir_p(File.dirname path)
      File.open(path, 'w') {|f| f.write(JSON.pretty_generate({:global => {:commands => {}, :options => {:option1 => 'hello'}}, :user => {}})) }

      begin
        subject
      rescue SystemExit => e
      end
    end

    context "--config global option should exist" do
      let(:option_string) { "--config=#{path}" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    end

    context "escort command should exist" do
      let(:option_string) { "escort -h" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }

      context "--create-config option for escort command should exist" do
        let(:option_string) { "escort --create-config=#{path}" }
        it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      end

      context "--create-default-config option for escort command should exist" do
        let(:option_string) { "escort --create-default-config" }
        it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      end

      context "--update-config option for escort command should exist" do
        let(:option_string) { "escort --update-config=#{path}" }
        it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      end

      context "--update-default-config option for escort command should exist" do
        let(:option_string) { "escort --update-default-config" }
        it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
      end
    end
  end
end
