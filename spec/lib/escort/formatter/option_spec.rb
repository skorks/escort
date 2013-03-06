describe Escort::Formatter::Option do
  let(:option) {Escort::Formatter::Option.new(name, details)}
  let(:name) { 'option1' }
  let(:details) do
    {:short=>short, :long=>"option1", :type=>type, :default=>default, :desc=>desc, :multi=>false}
  end
  let(:short) {:none}
  let(:type) {:string}
  let(:default) {'foo'}
  let(:desc) {'Option 1'}

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
end
