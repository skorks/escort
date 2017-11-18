describe "Escort basic app with dependent options", :integration => true do
  subject { Escort::App.create(option_string, &app_configuration) }

  context "when dependency specification has no 'on' parameter" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string

          opts.dependency :option1
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    let(:option_string) { "-f" }
    it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
  end

  context "when option dependent on presence of flag" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string

          opts.dependency :option1, :on => :flag1
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and flag is not present" do
      let(:option_string) { "-o foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and flag is present" do
      let(:option_string) { "-f -o foo" }
      it("it should exit successfully") { expect(subject).to exit_with_code(0) }
    end
  end

  context "when flag depends on another flag" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean, :default => true
          opts.opt :flag3, "Flag 3", :short => :none, :long => '--flag3', :type => :boolean
          opts.opt :flag4, "Flag 4", :short => :none, :long => '--flag4', :type => :boolean

          opts.dependency :flag3, :on => :flag1
          opts.dependency :flag4, :on => :flag2
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and other flag has a default value of false" do
      context "and other flag is present" do
        let(:option_string) { "--flag1 --flag3" }
        it("it should exit successfully") { expect(subject).to exit_with_code(0) }
      end

      context "and other flag is not present" do
        let(:option_string) { "--flag3" }
        it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
      end
    end

    context "and other flag has a default value of true" do
      context "and other flag is present" do
        let(:option_string) { "--flag2 --flag4" }
        it("it should exit successfully") { expect(subject).to exit_with_code(0) }
      end

      context "and other flag is not present" do
        let(:option_string) { "--flag4" }
        it("it should exit successfully") { expect(subject).to exit_with_code(0) }
      end

      context "and other flag negative option is used" do
        let(:option_string) { "--no-flag2 --flag4" }
        it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
      end
    end
  end

  context "when option dependent on presence of multiple other options" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
          opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true

          opts.dependency :option2, :on => [:flag1, :option1]
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and one of the other options is not present" do
      let(:option_string) { "-f --option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and none of the other options are present" do
      let(:option_string) { "--option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and all of the other options are present" do
      let(:option_string) { "-f -o bar --option2=foo" }
      it("it should exit successfully") { expect(subject).to exit_with_code(0) }
    end
  end

  context "when option dependent on other option value" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
          opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true

          opts.dependency :option2, :on => {:option1 => 'bar'}
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and other option is supplied with this value" do
      let(:option_string) { "-o bar --option2=foo" }
      it("it should exit successfully") { expect(subject).to exit_with_code(0) }
    end

    context "and other option is supplied with different value" do
      let(:option_string) { "-o baz --option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and other option is not supplied" do
      let(:option_string) { "--option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end
  end

  context "when option dependent on other option value and presence of yet another option" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
          opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true

          opts.dependency :option2, :on => [:flag1, {:option1 => 'bar'}]
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end

    context "and yet another option is not present" do
      let(:option_string) { "-o bar --option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and other option has different value" do
      let(:option_string) { "-o baz -f --option2=foo" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end

    context "and other option has the right value and yet another option is present" do
      let(:option_string) { "-o bar -f --option2=foo" }
      it("it should exit successfully") { expect(subject).to exit_with_code(0) }
    end
  end

  context "when option dependent on itself" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string

          opts.dependency :option1, :on => :option1
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    let(:option_string) { "-o bar" }
    it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
  end

  context "when dependency specified for non-existant option" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string

          opts.dependency :option2, :on => :option1
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    let(:option_string) { "-o bar" }
    it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
  end

  context "when option dependent on non-existant option" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string

          opts.dependency :option1, :on => :option2
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    let(:option_string) { "-o bar" }
    it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
  end

  context "when dependency is specified inline" do
    let(:app_configuration) do
      lambda do |app|
        app.options do |opts|
          opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
          opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :depends_on => :flag1
        end

        app.action do |options, arguments|
          Escort::IntegrationTestCommand.new(options, arguments).execute(result)
        end
      end
    end
    context "and dependency is satisfied" do
      let(:option_string) { "-f -o bar" }
      it("it should exit successfully") { expect(subject).to exit_with_code(0) }
    end

    context "and dependency is not satisfied" do
      let(:option_string) { "-o bar" }
      it("it should not exit successfully") { expect(subject).to_not exit_with_code(0) }
    end
  end
end
