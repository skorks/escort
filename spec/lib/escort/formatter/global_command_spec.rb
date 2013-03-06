describe Escort::Formatter::GlobalCommand do
  let(:command) { Escort::Formatter::GlobalCommand.new(setup)}
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }
  let(:context) {[]}
  let(:name) {:command1}
  let(:command_alias) {:c1}
  let(:aliases) {[command_alias]}
  let(:summary) {'app summary'}
  let(:description) {'app description'}

  let(:app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.summary summary
      app.description description

      app.command name, :aliases => aliases  do |command|
        command.action do |options, arguments|
        end
      end
    end
  end

  context "#description" do
    subject {command.description}

    context "when no description" do
      let(:description) {nil}
      it{subject.should == ''}
    end

    context "when has description" do
      let(:description) {'app description'}
      it{subject.should == description}
    end
  end

  context "#summary" do
    subject {command.summary}

    context "when no summary" do
      let(:summary) {nil}
      it{subject.should == ''}
    end

    context "when has summary" do
      let(:summary) {'app summary'}
      it{subject.should == summary}
    end
  end
end
