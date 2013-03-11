describe Escort::Setup::Configuration::Locator::Chaining do
  include FakeFS::SpecHelpers

  let(:locator) {Escort::Setup::Configuration::Locator::Chaining.new(filename)}
  let(:filename) {'.blahrc'}
  let(:home) {File.expand_path('~')}
  let(:pwd) {File.expand_path(File.join(home, 'blah', 'yadda', 'foo'))}
  let(:executing_directory) {File.expand_path(File.dirname($0))}

  let(:descending_locator) {Escort::Setup::Configuration::Locator::DescendingToHome.new(filename)}
  let(:executing_script_locator) {Escort::Setup::Configuration::Locator::ExecutingScriptDirectory.new(filename)}

  before do
    FileUtils.mkdir_p(executing_directory)
    FileUtils.mkdir_p(home)
    FileUtils.mkdir_p(pwd)
    Dir.chdir(pwd)
  end

  describe "#add_locator" do
    subject {locator.add_locator("blah")}
    it {subject.should == locator}
    it {subject.locators.size.should == 1}
  end

  describe "#locate" do
    subject {locator.locate}

    context "when no sub-locators specified" do
      it {subject.should be_nil}
    end

    context "when executing directory locator specified" do
      before do
        locator.add_locator(executing_script_locator)
      end

      let(:path) {File.join(executing_directory, filename)}

      context "and file should be found by it" do
        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end

        it {subject.should == path}
      end

      context "and file should not be found by it" do
        it {subject.should be_nil}
      end
    end

    context "when descending and current script locators are specified" do
      before do
        locator.
          add_locator(descending_locator).
          add_locator(executing_script_locator)
      end

      context "and file should not be found" do
        it {subject.should be_nil}
      end

      context "and file should be found by current script locator" do
        let(:path) {File.join(executing_directory, filename)}
        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end
        it {subject.should == path}
      end

      context "and file should be found by descending locator"do
        let(:path) {File.join(home, filename)}
        before do
          File.open(path, 'w') {|f| f.write("hello") }
        end
        it {subject.should == path}
      end
    end
  end
end
