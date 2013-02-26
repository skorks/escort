describe Escort::Utils do
  describe '::symbolize_keys' do
    subject {Escort::Utils.symbolize_keys(hash)}

    context "when single level hash" do
      let(:hash) { {'a' => 1, :b => 2} }
      it {subject[:a].should == 1}
      it {subject[:b].should == 2}
    end

    context "when hash has nested hashes" do
      let(:hash) { {'a' => 1, :b => {'c' => {'d' => 2}}} }
      it {subject[:a].should == 1}
      it {subject[:b][:c][:d].should == 2}
    end
  end

  describe '::tokenize_option_string' do
    subject {Escort::Utils.tokenize_option_string(option_string)}

    context "when standard option string" do
      let(:option_string) {"-a 1 --foo='bar blah' yadda"}
      it {subject.size.should == 4}
      it {subject[0].should == '-a'}
      it {subject[1].should == '1'}
      it {subject[2].should == '--foo=bar blah'}
      it {subject[3].should == 'yadda'}
    end
  end
end
