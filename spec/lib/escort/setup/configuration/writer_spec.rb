describe Escort::Setup::Configuration::Writer do
  include FakeFS::SpecHelpers
  let(:writer) {Escort::Setup::Configuration::Writer.new(path, data)}
  let(:path) {'/usr/alan/blah.json'}
  let(:data) { {:hello => :world} }

  describe "#write" do
    subject {writer.write}

    context "when path is nil" do
      let(:path) {nil}
      it {subject.should be_empty}
    end

    context "when path is not nil" do
      context "and the file does not exist" do
        it {subject.should_not be_empty}
        it {subject.path.should == path}
        it {subject.data.should == data}
        it("file should have the right contents") do
          subject
          json = File.read(path)
          hash = ::JSON.parse(json)
          actual_data = Escort::Utils.symbolize_keys(hash)
          actual_data.should == {:hello => "world"}
        end
      end

      context "and the file already exists" do
        before do
          FileUtils.mkdir_p(File.dirname path)
          FileUtils.touch(path)
        end
        it {subject.should be_empty}
      end
    end
  end

  describe "#update" do
    subject {writer.update}

    context "when file does not exist" do
      it {subject.should_not be_empty}
      it {subject.path.should == path}
      it {subject.data.should == data}
      it("file should have the right contents") do
        subject
        json = File.read(path)
        hash = ::JSON.parse(json)
        actual_data = Escort::Utils.symbolize_keys(hash)
        actual_data.should == {:hello => "world"}
      end
    end

    context "when file does exit" do
      let(:previous_data) { {:hello => :blah} }
      let(:data) { {:hello => :world, :foo => :bar} }
      before do
        FileUtils.mkdir_p(File.dirname path)
        File.open(path, 'w') {|f| f.write(JSON.pretty_generate(previous_data)) }
      end

      it {subject.should_not be_empty}
      it {subject.path.should == path}
      it {subject.data.should == data}
      it("file should have the right contents") do
        subject
        json = File.read(path)
        hash = ::JSON.parse(json)
        actual_data = Escort::Utils.symbolize_keys(hash)
        actual_data.should == {:hello=>"blah", :foo=>"bar"}
      end
    end
  end
end
