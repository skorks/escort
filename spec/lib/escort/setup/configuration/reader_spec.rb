describe Escort::Setup::Configuration::Reader do
  include FakeFS::SpecHelpers

  let(:reader) {Escort::Setup::Configuration::Reader.new(path)}
  let(:path) {'/usr/alan/blah.json'}
  let(:data) { {:hello => :world} }

  describe "#read" do
    subject {reader.read}

    context "when path not given" do
      let(:path) {nil}
      it{subject.should be_empty}
    end

    context "when configuration file not present" do
      before do
        FileUtils.mkdir_p(File.dirname path)
      end
      it{subject.should be_empty}
    end

    context "when configuration file not JSON" do
      before do
        FileUtils.mkdir_p(File.dirname path)
        File.open(path, 'w') {|f| f.write("hello") }
      end
      it{subject.should be_empty}
    end

    context "when configuration file present" do
      let(:config_data) { {:hello => :blah} }

      before do
        FileUtils.mkdir_p(File.dirname path)
        File.open(path, 'w') {|f| f.write(JSON.pretty_generate(config_data)) }
      end
      it {subject.data.should == {:hello => "blah"}}
    end
  end
end
