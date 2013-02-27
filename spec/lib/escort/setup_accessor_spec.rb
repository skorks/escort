describe Escort::SetupAccessor do
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }
  let(:global_app_configuration) do
    Escort::Setup::Dsl::Global.new do |app|
      app.options do |opts|
        opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
      end

      app.action do |options, arguments|
      end
    end
  end

  let(:command_app_configuration) do
  end

  let(:sub_command_app_configuration) do
  end

  describe '#options_for' do
    subject {setup.options_for(context)}

    context "when app has no sub commands" do
      let(:app_configuration) {global_app_configuration}

      context "and context is global" do
        let(:context) { [] }
        it(":option1 should be present") {subject[:option1].should_not be_nil}
      end

      context "and context is an unknown command" do
        let(:context) { ['hello'] }
        it(":option1 should not be present") {subject[:option1].should be_nil}
      end
    end
  end
end
