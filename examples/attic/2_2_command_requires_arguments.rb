#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.command :my_command, :description => "KJHLKJH askj aldkjfhakldfjh akdjfh alkdfhj alkdjhf alkjsdhf alkjsdhf aklsjdhf aklsjdhf akljdhf alkdjfh" do |command|
    command.requires_arguments

    command.options do |opts|
      opts.opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |options, arguments|
      puts "Action for my_command\noptions: #{options} \narguments: #{arguments}"
    end
  end
end
