shared_context "integration test setup", :integration => true do
  let(:result) { {} }

  before do
    empty_argv
    $stderr = StringIO.new
    $stdout = StringIO.new
    $stdin = StringIO.new
  end

  after do
    $stderr = STDERR
    $stdout = STDOUT
    $stdin = STDIN
  end

  class Command < ::Escort::ActionCommand::Base
    def execute(result)
      result[:command_name] = command_name
      result[:command_options] = command_options
      result[:options] = options
      result[:arguments] = arguments
      result[:config] = config if config
    end
  end

  def empty_argv
    while !ARGV.empty? do
      ARGV.delete_at(0)
    end
  end
end
