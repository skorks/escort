describe Escort::SetupAccessor do
  let(:command) { Escort::TestCommand.new(options, arguments, config) }
  let(:options) { {} }
  let(:arguments) { [] }
  let(:config) { {} }

  describe "#command_context" do
    subject {command.send(:command_context)}

    context "when command context already set" do
      before do
        command.instance_variable_set(:"@command_context", [:hello])
      end

      it {subject.should == [:hello]}
    end

    context "when command context not yet set" do
      context "and options hash is empty" do
        it {subject.should == []}
      end

      context "and options hash is of valid structure" do
        context "and command is global" do
          let(:options) { {:global => {:commands => {}}} }
          it {subject.should == []}
        end

        context "and command is child of global" do
          let(:options) { {:global => {:commands => {:command1 => {:commands => {}}}}} }
          it {subject.should == [:command1]}

          context "and no commands hash for sub command in options" do
            let(:options) { {:global => {:commands => {:command1 => {}}}} }
            it {subject.should == [:command1]}
          end
        end

        context "and command is grandchild of global" do
          let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {}}}}}}} }
          it {subject.should == [:command1, :sub_command1]}
        end

        context "and command is great grandchild of global" do
          let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {:sub_sub_command1 => {:commands => {}}}}}}}}} }
          it {subject.should == [:command1, :sub_command1, :sub_sub_command1]}
        end
      end
    end
  end

  describe "#command_name" do
    subject {command.send(:command_name)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}}} }
      it {subject.should == :global}
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}}}}} }
      it {subject.should == :command1}
    end

    context "when context is of size 2" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {}}}}}}} }
      it {subject.should == :sub_command1}
    end
  end

  describe "#command_options" do
    subject {command.send(:command_options)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}, :options => {:hello => :world}}} }
      it {subject.should == {:hello => :world}}
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}, :options => {:hello => :world}}}}} }
      it {subject.should == {:hello => :world}}
    end

    context "when context is of size 2" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {}, :options => {:hello => :world}}}}}}} }
      it {subject.should == {:hello => :world}}
    end
  end

  describe "#global_options" do
    subject {command.send(:global_options)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}, :options => {:hello => :world}}} }
      it {subject.should == {:hello => :world}}
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}}}, :options => {:hello => :world}}} }
      it {subject.should == {:hello => :world}}
    end
  end

  describe "#parent_options" do
    subject {command.send(:parent_options)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}, :options => {:hello => :world}}} }
      it {subject.should == {}}
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}}}, :options => {:hello => :world}}} }
      it {subject.should == {:hello => :world}}
    end

    context "when context is of size 2" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {}}}, :options => {:hello => :world}}}}} }
      it {subject.should == {:hello => :world}}
    end
  end

  describe "#grandparent_options" do
    subject {command.send(:grandparent_options)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}, :options => {:hello => :world}}} }
      it {subject.should == {}}
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}}}, :options => {:hello => :world}}} }
      it {subject.should == {}}
    end

    context "when context is of size 2" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {:sub_command1 => {:commands => {}}}}}, :options => {:hello => :world}}} }
      it {subject.should == {:hello => :world}}
    end
  end

  describe "#ancestor_options" do
    subject {command.send(:ancestor_options, generation_number)}

    context "when context is global" do
      let(:options) { {:global => {:commands => {}, :options => {:hello => :world}}} }

      context "and generation number is 0" do
        let(:generation_number) {0}
        it {subject.should == {:hello => :world}}
      end

      context "and generation number is 1" do
        let(:generation_number) {1}
        it {subject.should == {}}
      end

      context "and generation number is 2" do
        let(:generation_number) {2}
        it {subject.should == {}}
      end

      context "and generation number is 3" do
        let(:generation_number) {3}
        it {subject.should == {}}
      end
    end

    context "when context is of size 1" do
      let(:options) { {:global => {:commands => {:command1 => {:commands => {}, :options => {:foo => :bar}}}, :options => {:hello => :world}}} }

      context "and generation number is 0" do
        let(:generation_number) {0}
        it {subject.should == {:foo => :bar}}
      end

      context "and generation number is 1" do
        let(:generation_number) {1}
        it {subject.should == {:hello => :world}}
      end

      context "and generation number is 2" do
        let(:generation_number) {2}
        it {subject.should == {}}
      end

      context "and generation number is 3" do
        let(:generation_number) {3}
        it {subject.should == {}}
      end
    end
  end
end

module Escort
  class TestCommand < ::Escort::ActionCommand::Base
    def execute
    end
  end
end
