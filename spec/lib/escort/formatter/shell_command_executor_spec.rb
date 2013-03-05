describe Escort::Formatter::ShellCommandExecutor do
  let(:executor) {Escort::Formatter::ShellCommandExecutor.new(command)}
  let(:result) { [] }
  let(:new_shell_success_callback) {lambda{ |command, stdin, stdout, stderr| result << 'success' }}
  let(:current_shell_success_callback) {lambda{ |command, final_result| result << 'success' }}
  let(:error_callback) {lambda{ |command, error| result << 'error'; result << error.class }}

  describe "#execute_in_new_shell" do
    subject {executor.execute_in_new_shell(new_shell_success_callback, error_callback)}

    context "when command is invalid" do
      let(:command) { 'lx -z' }
      it("error callback should be executed") {subject; result.first.should == 'error'}
      it("should return nil") {subject.should be_nil}
    end

    context "when command is valid" do
      context "but options passed to it are invalid" do
        let(:command) { 'ls --foobar' }
        it("error callback should be executed") {subject; result.first.should == 'error'}
        it("command should produce an exit status error") {subject; result[1].should == Escort::InternalError}
        it("should return nil") {subject.should be_nil}
      end

      context "and options passed to it are valid" do
        let(:command) { 'ls -al' }
        it("success callback should be executed") {subject; result.first.should == 'success'}
        it("should not return nil") {subject.should_not be_nil}
      end
    end
  end

  describe "#execute_in_current_shell" do
    subject {executor.execute_in_current_shell(current_shell_success_callback, error_callback)}

    context "when command is invalid" do
      let(:command) { 'lx -z' }
      it("error callback should be executed") {subject; result.first.should == 'error'}
      it("should return nil") {subject.should be_nil}
    end

    context "when command is valid" do
      context "but options passed to it are invalid" do
        let(:command) { 'ls --foobar' }
        it("error callback should be executed") {subject; result.first.should == 'error'}
        it("command should produce an exit status error") {subject; result[1].should == Escort::InternalError}
        it("should return nil") {subject.should be_nil}
      end

      context "and options passed to it are valid" do
        let(:command) { 'ls -al' }
        it("success callback should be executed") {subject; result.first.should == 'success'}
        it("should not return nil") {subject.should_not be_nil}
      end
    end
  end
end
