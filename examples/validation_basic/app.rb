#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :multi_option, "Option that can be specified multiple times", :short => '-m', :long => '--multi', :type => :string, :multi => true
    opt :a_number, "Do stuff", :short => "-n", :long => '--number', :type => :int
  end

  app.validations do |opts|
    opts.validate(:global_option, "must be either global or local") { |option| ["global", "local"].include?(option) }
    opts.validate(:a_number, "must be between 10 and 20 exclusive") { |option| option > 10 && option < 20 }
  end

  app.command :my_command do |command|
    command.options do
      banner "Command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    #command.validations do
      #validate :do_stuff
    #end

    command.action do |global_options, command_options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end
end
