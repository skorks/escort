describe Escort::Formatter::Option do
  let(:option) {Escort::Formatter::Option.new(name, details, setup, context)}
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }
  let(:context) {[]}
  let(:name) { 'option1' }
  let(:details) do
    {:short=>short, :long=>"option1", :type=>type, :default=>default, :desc=>desc, :multi=>false}
  end
  let(:short) {:none}
  let(:type) {:string}
  let(:default) {'foo'}
  let(:desc) {'Option 1'}
  let(:app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
    end
  end

  describe "#usage" do
    subject {option.usage}

    context "when option is a flag" do
      let(:type) {:flag}

      context "and it has a default value of 'true'" do
        let(:default) {true}
        it {subject.should == '--option1, --no-option1'}
      end

      context "and its default value is 'false'" do
        let(:default) {false}
        it {subject.should == '--option1'}
      end
    end

    context 'when option is not a flag' do
      let(:type) {:string}

      context "and it has no short specification" do
        let(:short) {:none}
        it {subject.should == '--option1 <s>'}
      end

      context "and it has a short specification" do
        let(:short) {'o'}
        it {subject.should == '--option1 -o <s>'}
      end
    end
  end

  describe "#description" do
    subject {option.description}

    context "when no description" do
      let(:desc) {nil}
      context "and has no default value" do
        let(:default) {nil}
        it {subject.should == ''}
      end

      context "and has a default value" do
        let(:default) {"blah"}
        it {subject.should == '(default: blah)'}
      end
    end

    context "when has description" do
      context "and description end with dot" do
        let(:desc) {"Option 1."}

        context "and has no default value" do
          let(:default) {nil}
          it {subject.should == 'Option 1.'}
        end

        context "and has a default value" do
          let(:default) {"blah"}
          it {subject.should == 'Option 1. (Default: blah)'}
        end
      end

      context "and description does not end with dot" do
        let(:desc) {"Option 1"}

        context "and has no default value" do
          let(:default) {nil}
          it {subject.should == 'Option 1'}
        end

        context "and has a default value" do
          let(:default) {"blah"}
          it {subject.should == 'Option 1 (default: blah)'}
        end
      end
    end
  end

  describe "#has_conflicts?" do
    subject {option.has_conflicts?}
    context "when no conflicts defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_falsey}
    end

    context "when conflict is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :conflicts_with => :option2
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_truthy}
    end
  end

  describe "#has_dependencies?" do
    subject {option.has_dependencies?}
    context "when no dependencies defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_falsey}
    end

    context "when dependency is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :depends_on => :option2
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_truthy}
    end
  end

  describe "#has_validations?" do
    subject {option.has_validations?}
    context "when no validations defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_falsey}
    end

    context "when validations is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string

            opts.validate(:option1, "must be 'foo'") {|option| option == 'foo'}
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_truthy}
    end
  end

  describe "#conflicts" do
    subject {option.conflicts}
    context "when no conflicts defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == ''}
    end

    context "when conflict is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :conflicts_with => [:option2, :option3]
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
            opts.opt :option3, "Option3", :short => :none, :long => '--option3', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == 'conflicts with: --option2, --option3'}
    end
  end

  describe "#dependencies" do
    subject {option.dependencies}
    context "when no dependencies defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == ''}
    end

    context "when dependency is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :depends_on => :option2
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == 'depends on: --option2'}
    end
  end

  describe "#validations" do
    subject {option.validations}
    context "when no validations defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == []}
    end

    context "when validations is defined" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
            opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string

            opts.validate(:option1, "must be 'foo'") {|option| option == 'foo'}
            opts.validate(:option1, "must not be 'bar'") {|option| option != 'bar'}
          end

          app.action do |options, arguments|
          end
        end
      end
      it {subject.should == ["must be 'foo'", "must not be 'bar'"]}
    end
  end
end
