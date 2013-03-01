#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.requires_arguments

  app.options do |opts|
    opts.opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opts.opt :multi_option, "Option that can be specified multiple times alksjdfh lakjdfh adf alksdfh alkdfjh alsdfjhaskdjfh alsdkfjh alksfdjh akdfjh alkdsjf alksdjfh alksdfjh asdfjklh aslkdfhj aslkdfjh adfjkhl", :short => '-m', :long => '--multi', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    puts "Action \nglobal options: #{options} \narguments: #{arguments}"
  end
end
