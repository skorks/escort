describe "Escort basic app with options defined" do
  subject { Escort::App.create(option_string, &app_configuration) }
  let(:result) { [] }

  before do
    $stderr = StringIO.new
    $stdout = StringIO.new
  end

  after do
    $stderr = STDERR
    $stdout = STDOUT
  end

  let(:app_configuration) do
    ->(app) do
      app.options do |opts|
        opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
      end

      app.action do |options, arguments|
        result << :global
        result << {:option1 => options[:global][:options][:option1]}
      end
    end
  end

  context "when called with empty option string" do
    let(:option_string) { "" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action(:global, result) }
    it("option1 have its default value in action") { expect{subject}.to give_option_to_action_with_value(:option1, 'option 1', result) }
  end

  context "when called with option string with short code option" do
    let(:option_string) { "-o blah" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action(:global, result) }
    it("option1 have the value 'blah' in action") { expect{subject}.to give_option_to_action_with_value(:option1, 'blah', result) }
  end

  context "when called with option string with long code option" do
    let(:option_string) { "--option1=blah" }
    it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    it("should execute the global action") { expect{subject}.to execute_action(:global, result) }
    it("option1 have the value 'blah' in action") { expect{subject}.to give_option_to_action_with_value(:option1, 'blah', result) }
  end

  context "when called with option string with unknown option" do
    let(:option_string) { "-k" }
    it("should not exit with code 0") { expect{ subject }.not_to exit_with_code(0) }
  end
end
