#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.valid_with_no_arguments

  app.options do
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.action do |global_options, arguments|
    puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}"
  end
end
