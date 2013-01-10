#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.summary "An app that does crazy things"
  app.description "An app that asdfk df;adf a;df a;dfj a;df a;ldfkj a;lksdjf a;ldjf a;lfdj a;lsdfkj a;ldsfjk a;lksdfj a;lskdfj a;lkdfj a;ldfkj a;ldfjk a;ldfkj adf"

  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.command :my_command, :description => "Command that does stuff", :aliases => [:mc, :mooc] do |command|
    command.options do
      banner "Command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |global_options, command_options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end

  app.command :blah, :description => "Command that does stuff adlkfjal;sdf alsdkjfa;ldkfj a;lsdfjk a;lsdfj a;ldkfj a;ldfkj a;lsdfj a;lfdjk" do |command|
    command.options do
      banner "Command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |global_options, command_options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end
end
