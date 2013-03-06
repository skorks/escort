describe Escort::Formatter::Command do
  let(:command) { Escort::Formatter::Command.new(name, setup, context)}
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }
  let(:context) {[]}
  let(:name) {:command1}
  let(:command_alias) {:c1}
  let(:aliases) {[command_alias]}
  let(:summary) {'command summary'}
  let(:description) {'command description'}

  let(:app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.command name, :aliases => aliases  do |command|
        command.summary summary
        command.description description

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
      let(:description) {'command description'}
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
      let(:summary) {'command summary'}
      it{subject.should == summary}
    end
  end

  context "#has_aliases?" do
    subject {command.has_aliases?}

    context "when no aliases" do
      let(:aliases) {[]}
      it {subject.should be_false}
    end

    context "when has an alias" do
      let(:aliases) {[command_alias]}
      it {subject.should be_true}
    end
  end

  context "#aliases" do
    subject {command.aliases}

    context "when no aliases" do
      let(:aliases) {[]}
      it {subject.should == []}
    end

    context "when has an alias" do
      let(:aliases) {[command_alias]}
      it {subject.first.should == command_alias}
    end
  end

  context "#outline" do
    subject {command.outline}

    context "when no summary or description" do
      let(:summary) {nil}
      let(:description) {nil}
      it {subject.should == ''}
    end

    context "when no summary" do
      let(:summary) {nil}
      let(:description) {'desc 1'}
      it {subject.should == 'desc 1'}
    end

    context "when no description" do
      let(:summary) {'summary 1'}
      let(:description) {nil}
      it {subject.should == 'summary 1'}
    end
  end

  context "#aliases" do
    subject {command.name_with_aliases}

    context "when no aliases" do
      let(:aliases) {[]}
      it {subject.should == "command1"}
    end

    context "when has an alias" do
      let(:aliases) {[command_alias]}
      it {subject.should == "command1, #{command_alias}"}
    end
  end
end
