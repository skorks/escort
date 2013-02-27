describe Escort::Formatter::StringSplitter do
  let(:splitter) {Escort::Formatter::StringSplitter.new(max_segment_width)}

  describe "#split" do
    subject {splitter.split(string)}

    context "when segment width is 10" do
      let(:max_segment_width) { 10 }

      context "and string is 'abc123'" do
        let(:string) {'abc123'}
        it("should produce 1 segment") { subject.size.should == 1 }
        it("first segment should be 'abc123'") { subject[0].should == 'abc123' }
      end

      context "and string is 'abc1234567'" do
        let(:string) {'abc1234567'}
        it("should produce 1 segment") { subject.size.should == 1 }
        it("first segment should be 'abc1234567'") { subject[0].should == 'abc1234567' }
      end

      context "and string is 'abc123abc456'" do
        let(:string) {'abc123abc456'}
        it("should produce 2 segments") { subject.size.should == 2 }
        it("first segment should be 'abc123abc4'") { subject[0].should == 'abc123abc4' }
        it("first segment should be '56'") { subject[1].should == '56' }
      end

      context "and string is 'abc123abc456bbbcccddd'" do
        let(:string) {'abc123abc456bbbcccddd'}
        it("should produce 3 segments") { subject.size.should == 3 }
        it("first segment should be 'abc123abc4'") { subject[0].should == 'abc123abc4' }
        it("first segment should be '56bbbcccdd'") { subject[1].should == '56bbbcccdd' }
        it("first segment should be 'd'") { subject[2].should == 'd' }
      end
    end
  end
end
