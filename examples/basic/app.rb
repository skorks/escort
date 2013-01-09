#!/usr/bin/env ruby
require 'escort'

Escort::App.create do |app|
  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :multi_option, "Option that can be specified multiple times", :short => '-m', :long => '--multi', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    puts "Action for my_command\nglobal options: #{options} \narguments: #{arguments}"
  end
end
