describe Escort::Formatter::StringGrid do
  let(:width) {20}

  describe "#to_s" do
    subject {grid.to_s}

    context "when 2 rows and 3 columns" do
      context "no strings span multiple rows" do
        let(:grid) do
          Escort::Formatter::StringGrid.new(:columns => 3, :width => width) do |g|
            g.row 'a', 'b', 'c'
            g.row 1, 2, 3
          end
        end
        it("all rows should equal table width") do
          subject.split("\n").each do |val|
            val.length.should == width
          end
        end
        it {subject.should == "a b c               \n1 2 3               "}
      end

      context "first column string spans 4 rows" do
        let(:grid) do
          Escort::Formatter::StringGrid.new(:columns => 3, :width => width) do |g|
            g.row '123456789abcdefgh', 'b', 'c'
            g.row 1, 2, 3
          end
        end
        it("should have 5 rows") do
          subject.split("\n").size.should == 5
        end
        it("all rows should equal table width") do
          subject.split("\n").each do |val|
            val.length.should == width
          end
        end
        it { subject.should == "12345 b c           \n6789a               \nbcdef               \ngh                  \n1     2 3           " }
      end
      context "last column string spans 2 rows" do
        let(:grid) do
          Escort::Formatter::StringGrid.new(:columns => 3, :width => width) do |g|
            g.row 'a', 'b', 'c'
            g.row 1, 2, "123456789abcdefghijk"
          end
        end
        it("should have 3 rows") do
          subject.split("\n").size.should == 3
        end
        it("all rows should equal table width") do
          subject.split("\n").each do |val|
            val.length.should == width
          end
        end
        it { subject.should == "a b c               \n1 2 123456789abcdef \n    ghijk           " }
      end
    end
  end
end
