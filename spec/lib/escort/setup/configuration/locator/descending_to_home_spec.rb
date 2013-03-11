describe Escort::Setup::Configuration::Locator::DescendingToHome do
  include FakeFS::SpecHelpers

  let(:locator) {Escort::Setup::Configuration::Locator::DescendingToHome.new(filename)}
  let(:filename) {'.blahrc'}
  let(:home) {File.expand_path('~')}
  let(:pwd) {File.expand_path(File.join(home, 'blah', 'yadda', 'foo'))}

  before do
    FileUtils.mkdir_p(home)
    FileUtils.mkdir_p(pwd)
    Dir.chdir(pwd)
  end

  describe "#locate" do
    subject {locator.locate}

    context "when file does not exist anywhere in the relevant directories" do
      it {subject.should be_nil}
    end

    context "when file exists" do
      context "in the top directory of search" do
        let(:file_location) {File.expand_path(File.join(home, 'blah', 'yadda', 'foo'))}
        let(:path) {File.join(file_location, filename)}

        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end

        it {subject.should == path}
      end

      context "in one of the middle directories of search" do
        let(:file_location) {File.expand_path(File.join(home, 'blah', 'yadda'))}
        let(:path) {File.join(file_location, filename)}

        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end

        it {subject.should == path}
      end

      context "in the home directory" do
        let(:file_location) {File.expand_path(home)}
        let(:path) {File.join(file_location, filename)}

        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end

        it {subject.should == path}
      end
    end
  end
end
