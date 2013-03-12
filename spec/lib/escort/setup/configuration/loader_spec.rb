describe Escort::Setup::Configuration::Loader do
  include FakeFS::SpecHelpers

  let(:loader) {Escort::Setup::Configuration::Loader.new(setup, auto_options)}
  let(:setup) { Escort::SetupAccessor.new(app_configuration) }
  let(:auto_options) {Escort::AutoOptions.new({})}

  describe "#default_config_path" do
    subject {loader.default_config_path}

    context "when setup has config file" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.config_file '.test1rc'
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end
        end
      end
      it {subject.should == File.join(File.expand_path('~'), '.test1rc')}
    end

    context "when setup has no config file" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end
        end
      end
      it {subject.should be_nil }
    end
  end

  describe "#configuration" do
    subject {loader.configuration}


    context "when setup has config file" do
      context "and config file is autocreatable" do
        let(:app_configuration) do
          Escort::Setup::Dsl::Global.new do |app|
            app.config_file '.test1rc', :autocreate => true
            app.options do |opts|
              opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
            end
          end
        end
        it {subject.should_not be_nil}
        it {subject.should_not be_empty}
        it {subject; File.should exist File.join(File.expand_path('~'), '.test1rc') }
      end

      context "and config file is not autocreatable" do
        let(:app_configuration) do
          Escort::Setup::Dsl::Global.new do |app|
            app.config_file '.test1rc'
            app.options do |opts|
              opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
            end
          end
        end
        it {subject.should_not be_nil}
        it {subject.should be_empty}
      end
    end

    context "when setup has no config file" do
      let(:app_configuration) do
        Escort::Setup::Dsl::Global.new do |app|
          app.options do |opts|
            opts.opt :option1, "option1", :short => :none, :long => '--option1', :type => :string
          end
        end
      end
      it {subject.should be_empty}
    end
  end
end
