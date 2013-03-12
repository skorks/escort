describe Escort::Setup::Configuration::Generator do

  let(:generator) {Escort::Setup::Configuration::Generator.new(setup)}
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }


  describe "#default_data" do
    subject {generator.default_data}

    context "when basic configuration" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it("should have a user config") {subject[:user].should_not be_nil}
      it("user config should be empty") {subject[:user].should be_empty}
      it("shoud have a global config") {subject[:global].should_not be_nil}
      it("global config should not be empty") {subject[:global].should_not be_empty}
      it("should have a global commands config") {subject[:global][:commands].should_not be_nil}
      it("global commands config should be empty") {subject[:global][:commands].should be_empty}
      it("should have a global options config") {subject[:global][:options].should_not be_nil}
      it("global options config should not be empty") {subject[:global][:options].should_not be_empty}
      it("options config should have a key for configured option") {subject[:global][:options].keys.size.should == 1}
      it("options config key for configured config should be nil when no default value") {subject[:global][:options][:option1].should be_nil}

      context "and configured option has default value" do
        let(:app_configuration) do
          Escort::Setup::Dsl::Global.new do |app|
            app.options do |opts|
              opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string, :default => "hello"
            end

            app.action do |options, arguments|
            end
          end
        end
        it("options config key for configured config should equal to default value") {subject[:global][:options][:option1].should == 'hello'}
      end
    end

    context "when suite configuration" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end

          app.command :command1, :aliases => [:c1, :com1]  do |command|
            command.options do |opts|
              opts.opt :option2, "option2", :short => :none, :long => '--option2', :type => :string, :default => 'blah'
            end
          end
        end
      end

      it("should have a global commands config") {subject[:global][:commands].should_not be_nil}
      it("global commands config should be empty") {subject[:global][:commands].should_not be_empty}
      it("command1 commands config should not be nil") {subject[:global][:commands][:command1][:commands].should_not be_nil}
      it("command1 commands config should be empty") {subject[:global][:commands][:command1][:commands].should be_empty}
      it("command1 options config should not be nil") {subject[:global][:commands][:command1][:options].should_not be_nil}
      it("command1 options config should not be empty") {subject[:global][:commands][:command1][:options].should_not be_empty}
      it("command1 options option value should be the same as default value") {subject[:global][:commands][:command1][:options][:option2].should == 'blah'}
    end

    context "when suite with sub commands configuration" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end

          app.command :command1, :aliases => [:c1, :com1]  do |command|
            command.options do |opts|
              opts.opt :option2, "option2", :short => :none, :long => '--option2', :type => :string, :default => 'blah'
            end

            command.command :sub_command1 do |command|
              command.options do |opts|
                opts.opt :option3, "option3", :short => :none, :long => '--option3', :type => :string, :default => 'yadda'
              end
            end
          end
        end
      end

      it("command1 commands config should not be nil") {subject[:global][:commands][:command1][:commands].should_not be_nil}
      it("command1 commands config should not be empty") {subject[:global][:commands][:command1][:commands].should_not be_empty}
      it("sub_command1 command config should not be nil") {subject[:global][:commands][:command1][:commands][:sub_command1][:commands].should_not be_nil}
      it("sub_command1 command config should be empty") {subject[:global][:commands][:command1][:commands][:sub_command1][:commands].should be_empty}
      it("sub_command1 options config should not be nil") {subject[:global][:commands][:command1][:commands][:sub_command1][:options].should_not be_nil}
      it("sub_command1 options config should not be empty") {subject[:global][:commands][:command1][:commands][:sub_command1][:options].should_not be_empty}
      it("sub_command1 options option value should be the same as default value") {subject[:global][:commands][:command1][:commands][:sub_command1][:options][:option3].should == 'yadda'}
    end
  end
end
