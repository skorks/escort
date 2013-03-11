describe Escort::Setup::Configuration::Locator::SpecifiedDirectory do
  include FakeFS::SpecHelpers

  let(:locator) {Escort::Setup::Configuration::Locator::SpecifiedDirectory.new(filename, directory)}
  let(:filename) {'.blahrc'}
  let(:directory) {'/usr/alan/yadda'}
  let(:path) {File.join(directory, filename)}

  describe "#locate" do
    subject {locator.locate}

    context "when directory does not exist" do
      it {subject.should be_nil}
    end

    context "when file does not exist in directory" do
      before do
        FileUtils.mkdir_p(directory)
      end

      it {subject.should be_nil}
    end

    context "when file exists in directory" do
      before do
        FileUtils.mkdir_p(directory)
        File.open(path, 'w') {|f| f.write("hello") }
      end

      it {subject.should == path}
    end
  end
end
