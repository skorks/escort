describe Escort::Setup::Configuration::MergeTool do
  let(:merge_tool) {Escort::Setup::Configuration::MergeTool.new(new_config_hash, old_config_hash)}

  describe "#config_hash" do
    subject {merge_tool.config_hash}

    context "when there is a new command" do
      let(:old_config_hash) { {:global => {:commands =>{}, :options => {:option1 => nil}}, :user => {:hello => :world}} }
      let(:new_config_hash) { {:global => {:commands =>{:command1 => {:commands => {}, :options => {}}}, :options => {}}, :user => {}} }

      it("should be part of the config"){subject[:global][:commands][:command1].should_not be_nil}
    end

    context "when there is a new option for an old command" do
      let(:old_config_hash) { {:global => {:commands =>{}, :options => {:option1 => nil}}, :user => {:hello => :world}} }
      let(:new_config_hash) { {:global => {:commands =>{}, :options => {:option1 => nil, :option2 => nil}}, :user => {}} }

      it("should be part of the config"){subject[:global][:options].keys.should include(:option2) }
    end

    context "when an old option for a command is no longer there" do
      let(:old_config_hash) { {:global => {:commands =>{}, :options => {:option1 => nil}}, :user => {:hello => :world}} }
      let(:new_config_hash) { {:global => {:commands =>{}, :options => {:option2 => nil}}, :user => {}} }

      it("should not be part of the config"){subject[:global][:options].keys.should_not include(:option1) }
    end

    context "when old config hash has user supplied value for option" do
      let(:old_config_hash) { {:global => {:commands =>{}, :options => {:option1 => :hello}}, :user => {:hello => :world}} }
      let(:new_config_hash) { {:global => {:commands =>{}, :options => {:option1 => nil}}, :user => {}} }

      it("should retain the user supplied value for option"){subject[:global][:options][:option1].should == :hello }
    end

    context "when old user hash has values" do
      let(:old_config_hash) { {:global => {:commands =>{}, :options => {}}, :user => {:hello => :world}} }
      let(:new_config_hash) { {:global => {:commands =>{}, :options => {}}, :user => {}} }
      it("should retain the user config values"){subject[:user][:hello].should == :world}
    end
  end
end
