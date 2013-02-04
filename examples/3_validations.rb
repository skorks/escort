#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opts.opt :multi_option, "Option that can be specified multiple times", :short => '-m', :long => '--multi', :type => :string, :multi => true
    opts.opt :a_number, "Do stuff", :short => "-n", :long => '--number', :type => :int
  end

  app.validations do |opts|
    opts.validate(:global_option, "must be either 'global' or 'local'") { |option| ["global", "local"].include?(option) }
    opts.validate(:a_number, "must be between 10 and 20 exclusive") { |option| option > 10 && option < 20 }
  end

  app.command :my_command do |command|
    command.options do |opts|
      opts.opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
      opts.opt :string_with_format, "String with format", :short => "-f", :long => '--format', :type => :string, :default => "blah yadda11111111111"
    end

    command.validations do |opts|
      opts.validate(:string_with_format, "should be two words") {|option| option =~ /\w\s\w/}
      opts.validate(:string_with_format, "should be at least 20 characters long") {|option| option.length >= 20}
    end

    command.action do |options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end
end
