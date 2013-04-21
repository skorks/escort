describe Escort::SetupAccessor do
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }

  let(:global_app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
        opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true
        opts.opt :int_option, "Int option", :short => '-i', :long => '--int-option', :type => :int
        opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean, :default => true
        opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean

        opts.conflict :flag1, :flag2
        opts.dependency :option1, :on => :flag1
        opts.validate(:int_option, "must be greater than 10") { |option| option > 10 }
      end

      app.action do |options, arguments|
      end
    end
  end

  let(:command_app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
      end

      app.command :command1  do |command|
        command.options do |opts|
          opts.opt :option1, "Option1 for command1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1 command 1"
          opts.opt :flag_for_command1, "Flag for command 1", :short => :none, :long => '--flag-for-command1', :type => :boolean

          opts.dependency :option1, :on => :flag_for_command1
        end

        command.action do |options, arguments|
        end
      end

      app.command :command2, :aliases => :c2  do |command|
        command.options do |opts|
          opts.opt :optionb, "Optionb", :short => :none, :long => '--optionb', :type => :string, :multi => true
          opts.opt :float_option, "Float option", :short => '-d', :long => '--float-option', :type => :float

          opts.conflict :optionb, :float_option
          opts.validate(:float_option, "must be less than 5") { |option| option < 5 }
        end

        command.action do |options, arguments|
        end
      end

      app.action do |options, arguments|
      end
    end
  end

  let(:sub_command_app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
      end

      app.command :command2, :aliases => :c2  do |command|
        command.options do |opts|
          opts.opt :optionb, "Optionb", :short => :none, :long => '--optionb', :type => :string, :multi => true
          opts.opt :float_option, "Float option", :short => '-d', :long => '--float-option', :type => :float

          opts.conflict :optionb, :float_option
          opts.validate(:float_option, "must be less than 5") { |option| option < 5 }
        end

        command.command :sub_command1  do |command|
          command.options do |opts|
            opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean
          end

          command.action do |options, arguments|
          end
        end

        command.command :sub_command2  do |command|
          command.options do |opts|
            opts.opt :sub_option1, "Sub option1", :short => '-s', :long => '--sub-option1', :type => :string
            opts.validate(:sub_option1, "must be 'x' or 'y'") { |option| ['x', 'y'].include? option }
          end

          command.action do |options, arguments|
          end
        end

        command.action do |options, arguments|
        end
      end

      app.action do |options, arguments|
      end
    end
  end

  describe '#options_for' do
    let(:options) {setup.options_for(context)}

    context "when app has no sub commands" do
      let(:app_configuration) {global_app_configuration}

      context "and context is global" do
        let(:context) { [] }
        it(":option1 should be present") {options[:option1].should_not be_nil}
      end

      context "and context is an unknown command" do
        let(:context) { ['hello'] }
        it("should not raise an exception") { expect{options}.to_not raise_error }
        it("result should be a hash") { options.class.should == Hash }
        it("result should be empty") { options.should be_empty }
      end

      context "and no context passed in at all" do
        let(:options) {setup.options_for}
        it(":option1 should be present") {options[:option1].should_not be_nil}
      end

      context "and context is nil" do
        let(:context) { nil }
        it(":option1 should be present") {options[:option1].should_not be_nil}
      end

      context "and context is not an array" do
        let(:context) { 'hello' }
        it("should not raise an exception") { expect{options}.to_not raise_error }
      end
    end

    context "when app has one level of sub commands" do
      let(:app_configuration) {command_app_configuration}

      context "and context is a known command" do
        let(:context) { ['command1'] }
        it("result should be a hash") { options.class.should == Hash }
        it("result should not be empty") { options.should_not be_empty }
        it(":option1 should be present") {options[:option1].should_not be_nil}
      end
    end

    context "when app has multiple levels of sub commands" do
      let(:app_configuration) {sub_command_app_configuration}

      context "and context is a known sub command" do
        let(:context) { ['command2', 'sub_command2'] }
        it("result should be a hash") { options.class.should == Hash }
        it("result should not be empty") { options.should_not be_empty }
        it(":sub_option1 should be present") {options[:sub_option1].should_not be_nil}
      end
    end
  end

  describe '#conflicting_options_for' do
    #TODO implement
  end

  describe '#validations_for' do
    #TODO implement
  end

  describe '#dependencies_for' do
    #TODO implement
  end

  describe '#command_names_for' do
    #TODO implement
  end

  describe '#canonical_command_names_for' do
    #TODO implement
  end

  describe '#action_for' do
    #TODO implement
  end

  describe '#arguments_required_for' do
    #TODO implement
  end

  describe '#has_config_file?' do
    #TODO implement
  end

  describe '#config_file_autocreatable?' do
    #TODO implement
  end

  describe '#config_file' do
    #TODO implement
  end

  describe '#summary_for' do
    #TODO implement
  end

  describe '#description_for' do
    #TODO implement
  end

  describe '#command_description_for' do
    #TODO implement
  end

  describe '#command_summary_for' do
    #TODO implement
  end

  describe '#command_aliases_for' do
    #TODO implement
  end

  describe '#add_global_option' do
    #TODO implement
  end

  describe '#add_global_command' do
    #TODO implement
  end
end
