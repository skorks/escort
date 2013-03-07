describe Escort::Formatter::StreamOutputFormatter do
  let(:formatter) {Escort::Formatter::StreamOutputFormatter.new(stream, :max_output_width => output_width)}
  let(:stream) { StringIO.new }
  let(:output_width) { 10 }
  let(:output) {stream.readlines}

  describe "#print" do
    subject {formatter.print(string)}

    before { subject; stream.rewind }

    context "when string is less than output_width" do
      let(:string) {'12345'}
      it("stream should have one line") {output.first.should == string}
    end

    context "when string is greater than output width" do
      let(:string) {'123456789abcd'}
      it("stream should have two lines") {output.should == ["123456789a\n", "bcd"]}
    end

    context "when string is has newlines in it" do
      context "and both lines less than output width" do
        let(:string) {"1234567\n89abcd"}
        it("stream should have two lines") {output.should == ["1234567\n", "89abcd"]}
      end

      context "and first line greater than output width" do
        let(:string) {"123456789abcd\nefg"}
        it("stream should have three lines") {output.should == ["123456789a\n", "bcd\n", "efg"]}
      end
    end
  end

  describe "#puts" do
    subject {formatter.puts(string, options)}
    let(:string) {'hello'}
    let(:options) { {:newlines => newlines} }
    let(:newlines) {1}

    before { subject; stream.rewind }

    context "when newlines" do
      context "is zero" do
        let(:newlines) {0}
        let(:string) {"123456789abcd\nefg"}
        it("stream should have three lines") {output.should == ["123456789a\n", "bcd\n", "efg"]}
      end

      context "not specified" do
        subject {formatter.puts(string)}
        let(:string) {"123"}
        it("stream should have one newline") {output.should == ["123\n"]}
      end

      context "is two" do
        let(:string) {"123"}
        let(:newlines) {2}
        it("stream should have two newlines") {output.should == ["123\n", "\n"]}
      end
    end
  end

  describe "#newline" do
    subject {formatter.newline(newline_count)}
    let(:newline_count) {1}

    before { subject; stream.rewind }

    context "when newline count not specified" do
      subject {formatter.newline}
      it("stream should have one newline") {output.should == ["\n"]}
    end

    context "when newline count is 2" do
      let(:newline_count) {2}
      it("stream should have two newlines") {output.should == ["\n", "\n"]}
    end
  end

  describe "#indent" do
    subject {formatter.indent(indent_width, &indented_block)}

    let(:indented_block) do
      lambda {|f| f.print string}
    end

    before { subject; stream.rewind }

    context "when indent is 0" do
      let(:indent_width) {0}

      context "and we print a string less than output_width" do
        let(:string) {'12345'}
        it("stream should have one line") {output.should == ['12345']}
      end

      context "and we print a string greater than output width" do
        let(:string) {'123456789abcd'}
        it("stream should have two lines") {output.should == ["123456789a\n", "bcd"]}
      end

      context "and we print a string that has newlines in it" do
        context "and both lines are less than output width" do
          let(:string) {"1234567\n89abcd"}
          it("stream should have two lines") {output.should == ["1234567\n", "89abcd"]}
        end

        context "and first line is greater than output width" do
          let(:string) {"123456789abcd\nefg"}
          it("stream should have three lines") {output.should == ["123456789a\n", "bcd\n", "efg"]}
        end
      end
    end

    context "when indent is 1" do
      let(:indent_width) {1}

      context "and we print a string less than output_width" do
        let(:string) {'12345'}
        it("stream should have one line") {output.should == [' 12345']}
      end

      context "and we print a string greater than output width" do
        let(:string) {'123456789abcd'}
        it("stream should have two lines") {output.should == [" 123456789\n", " abcd"]}
      end

      context "and we print a string that has newlines in it" do
        context "and both lines are less than output width" do
          let(:string) {"1234567\n89abcd"}
          it("stream should have two lines") {output.should == [" 1234567\n", " 89abcd"]}
        end

        context "and first line is greater than output width" do
          let(:string) {"123456789abcd\nefg"}
          it("stream should have three lines") {output.should == [" 123456789\n", " abcd\n", " efg"]}
        end
      end
    end

    context "when indent is 3" do
      let(:indent_width) {3}

      context "and we print a string less than output_width" do
        let(:string) {'12345'}
        it("stream should have one line") {output.should == ['   12345']}
      end

      context "and we print a string greater than output width" do
        let(:string) {'123456789abcd'}
        it("stream should have two lines") {output.should == ["   1234567\n", "   89abcd"]}
      end

      context "and we print a string that has newlines in it" do
        context "and both lines are less than output width" do
          let(:string) {"1234567\n89abcd"}
          it("stream should have two lines") {output.should == ["   1234567\n", "   89abcd"]}
        end

        context "and first line is greater than output width" do
          let(:string) {"123456789abcd\nefg"}
          it("stream should have three lines") {output.should == ["   1234567\n", "   89abcd\n", "   efg"]}
        end
      end
    end
  end

  context "output combinations" do
    subject do
      Escort::Formatter::StreamOutputFormatter.new(stream, :max_output_width => output_width) do |f|
        f.print "the quick"
        f.newline
        f.print "brown fox"
        f.print "jumped over the"
        f.print "lazy dog"
        f.newline
        f.puts 'rainbow suspenders'
        f.indent(3) do |f|
          f.puts "blah blah blah blah"
          f.newline(2)
          f.indent(2) do |f|
            f.puts "indent me good"
            f.print "foo"
            f.print "foo"
            f.print "foo"
            f.newline
            f.puts "exit", :newlines => 4
          end
        end
      end
    end
    let(:stream) { StringIO.new }
    let(:output_width) { 10 }

    let(:output) {stream.readlines}

    before { subject; stream.rewind }

    context "lines should not be greater than output width" do
      it do
        output.each do |line|
          line.strip.length.should be <= output_width
        end
      end
    end
  end
end
