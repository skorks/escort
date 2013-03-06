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

  context "#script_name" do
    subject {command.script_name}

    context "when context is global" do
      let(:context) {[]}
      it{subject.split(" ").count.should == 1}
    end

    context "when context is not global" do
      let(:context) {[:hello]}
      it{subject.split(" ").count.should == 2}
      it{subject.split(" ").include?('hello').should be_true}
    end
  end

  context "#child_commands" do
    subject {command.child_commands}

    context "when no child commands" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_empty}
    end

    context "when has child commands" do
      it {subject.should_not be_empty}
      it {subject.count.should == 1}
      it {subject.first.should == :command1}
    end
  end

  context "#has_child_commands?" do
    subject {command.has_child_commands?}

    context "when no child commands" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_false}
    end

    context "when has child commands" do
      it {subject.should be_true}
    end
  end

  context "#requires_arguments?" do
    subject {command.requires_arguments?}

    context "when arguments not required" do
      it {subject.should be_false}
    end

    context "when arguments are required" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.requires_arguments
          app.action do |options, arguments|
          end
        end
      end
      it {subject.should be_true}
    end
  end

  context "#usage" do
    subject {command.usage}

    before do
      $0 = 'hello'
    end

    context "when global command with no children" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.action do |options, arguments|
          end
        end
      end
      it {subject.split(" ").first.should == 'hello'}
      it {subject.split(" ")[1].should == '[options]'}
      it {subject.split(" ")[2].should == '[arguments]'}
    end

    context "when global command with children" do
      it {subject.split(" ").first.should == 'hello'}
      it {subject.split(" ")[1].should == '[options]'}
      it {subject.split(" ")[2].should == 'command'}
      it {subject.split(" ")[3].should == '[command_options]'}
      it {subject.split(" ")[4].should == '[arguments]'}
    end

    context "when global command and requires arguments" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.requires_arguments
          app.action do |options, arguments|
          end
        end
      end
      it {subject.split(" ").last.should == 'arguments'}
    end

    context "when does not require arguments" do
      it {subject.split(" ").last.should == '[arguments]'}
    end

    context "when child command context with no children of its own" do
      let(:context){[:command1]}
      it {subject.split(" ").first.should == 'hello'}
      it {subject.split(" ")[1].should == '[options]'}
      it {subject.split(" ")[2].should == 'command1'}
      it {subject.split(" ")[3].should == '[command1_options]'}
      it {subject.split(" ")[4].should == '[arguments]'}
    end
  end
end
