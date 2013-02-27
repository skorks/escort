describe Escort::Utils do
  describe '::symbolize_keys' do
    subject {Escort::Utils.symbolize_keys(hash)}

    context "when single level hash" do
      let(:hash) { {'a' => 1, :b => 2} }
      it("the :a key should be a symbol") {subject[:a].should == 1}
      it("the :b key should be a symbol") {subject[:b].should == 2}
    end

    context "when hash has nested hashes" do
      let(:hash) { {'a' => 1, :b => {'c' => {'d' => 2}}} }
      it("the :a key should be a symbol") {subject[:a].should == 1}
      it("the nested keys, :b, :c and :d should all be symbols") {subject[:b][:c][:d].should == 2}
    end
  end

  describe '::tokenize_option_string' do
    subject {Escort::Utils.tokenize_option_string(option_string)}

    context "when option string has short option, long option and argument" do
      let(:option_string) {"-a 1 --foo='bar blah' yadda"}
      it("tokenized string should have 4 values") {subject.size.should == 4}
      it("the short option should be a separate token") {subject[0].should == '-a'}
      it("the short option value should be a separate token") {subject[1].should == '1'}
      it("the long option and value should be one token") {subject[2].should == '--foo=bar blah'}
      it("the argument should be a separate token") {subject[3].should == 'yadda'}
    end
  end
end
