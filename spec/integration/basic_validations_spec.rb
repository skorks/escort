describe "Escort basic app with validations", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  context "when validation exists for non-existant option" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option1, "Option 1", :short => '-o', :long => '--option1', :type => :string
        end

        app.validations do |opts|
          opts.validate(:option2, "must be either 'foo' or 'bar'") { |option| ["foo", "bar"].include?(option) }
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    let(:option_string) { "-o bar" }

    it("should exit with code 2") { expect{ subject }.to exit_with_code(2) }
  end

  context "when option has a validation" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option1, "Option 1", :short => '-o', :long => '--option1', :type => :string
        end

        app.validations do |opts|
          opts.validate(:option1, "must be either 'foo' or 'bar'") { |option| ["foo", "bar"].include?(option) }
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and validation fails" do
      let(:option_string) { "-o baz" }
      it("should exit with code 3") { expect{ subject }.to exit_with_code(3) }
    end

    context "and validation does not fail" do
      let(:option_string) { "-o foo" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    end
  end

  context "when option has multiple validations" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option2, "Option 2", :short => :none, :long => '--option2', :type => :string
        end

        app.validations do |opts|
          opts.validate(:option2, "must be two words") {|option| option =~ /\w\s\w/}
          opts.validate(:option2, "must be at least 20 characters long") {|option| option.length >= 20}
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and one validation fails" do
      let(:option_string) { "--option2='hb'" }
      it("should exit with code 3") { expect{ subject }.to exit_with_code(3) }
    end

    context "and the other validation fails" do
      let(:option_string) { "--option2='h bssfs'" }
      it("should exit with code 3") { expect{ subject }.to exit_with_code(3) }
    end

    context "and both validations pass" do
      let(:option_string) { "--option2='h bssfsfsdfsdfsfsdsf'" }
      it("should exit with code 0") { expect{ subject }.to exit_with_code(0) }
    end
  end
end
