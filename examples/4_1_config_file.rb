#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opts.opt :multi_option, "Option that can be specified multiple times alksjdfh lakjdfh adf alksdfh alkdfjh alsdfjhaskdjfh alsdkfjh alksfdjh akdfjh alkdsjf alksdjfh alksdfjh asdfjklh aslkdfhj aslkdfjh adfjkhl", :short => '-m', :long => '--multi', :type => :string, :multi => true
  end

  app.config_file ".apprc", :autocreate => true

  app.summary "Sum1"
  app.description "Desc1"

  app.command :my_command, :description => "KJHLKJH askj aldkjfhakldfjh akdjfh alkdfhj alkdjhf alkjsdhf alkjsdhf aklsjdhf aklsjdhf akljdhf alkdjfh", :aliases => [:my1, :my2] do |command|
    #command.requires_arguments
    command.summary "Sum2"
    command.description "Desc2"

    command.options do |opts|
      opts.opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |options, arguments|
      puts "Action for my_command\noptions: #{options} \narguments: #{arguments}"
    end

    command.command :nested_command, :description => "A nested sub command" do |command|
      command.options do |opts|
        opts.opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
      end

      command.action do |options, arguments|
        puts "Action for my_command nested_command\noptions: #{options} \narguments: #{arguments}"
      end
    end
  end

  app.action do |options, arguments, config|
    puts "Action \nglobal options: #{options} \narguments: #{arguments}\nconfig: #{config}"
  end
end
