#!/usr/bin/env ruby
require 'escort'

Escort::App.create do |app|
  #app.default "-g"

  app.options do
    banner "my script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.action do |global_options, command_options, arguments|
    #actually do the work for this command here
  end

  #app.before do |command_name, global_options, command_options, arguments|
    ##executes before each command
  #end

  app.on_error do |error|
    #handle all errors here
  end
end
