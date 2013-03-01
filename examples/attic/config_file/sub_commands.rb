#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.summary "An app that does crazy things"
  app.description "An app that asdfk df;adf a;df a;dfj a;df a;ldfkj a;lksdjf a;ldjf a;lfdj a;lsdfkj a;ldsfjk a;lksdfj a;lskdfj a;lkdfj a;ldfkj a;ldfjk a;ldfkj adf"

  app.config_file ".apprc"#, :autocreate => true

  app.options do
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :another_option, "Another option", :short => '-a', :long => '--another', :type => :string, :default => "hello"
    opt :blah, "Blah options", :short => '-b', :long => '--blah', :type => :flag
  end

  app.validations do |opts|
    opts.validate(:global_option, "must be either 'global' or 'local'") { |option| ["global", "local"].include?(option) }
  end

  app.command :my_command, :description => "KJHLKJH askj aldkjfhakldfjh akdjfh alkdfhj alkdjhf alkjsdhf alkjsdhf aklsjdhf aklsjdhf akljdhf alkdjfh" do |command|
    command.options do
      opt :command_option, "Command option", :short => '-c', :long => '--command', :type => :string, :default => "blah"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |global_options, command_options, arguments, config|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}\nuser config data: #{config}"
    end
  end

  #app.action do |global_options, arguments, config|
    #puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}\nuser config data: #{config}"
    ##puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}"
  #end
end
