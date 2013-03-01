#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.summary "An app that does crazy things"
  app.description "An app that asdfk df;adf a;df a;dfj a;df a;ldfkj a;lksdjf a;ldjf a;lfdj a;lsdfkj a;ldsfjk a;lksdfj a;lskdfj a;lkdfj a;ldfkj a;ldfjk a;ldfkj adf"

  #app.config_file ".apprc", :autocreate => true

  app.options do
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :another_option, "Another option", :short => '-a', :long => '--another', :type => :string, :default => "hello"
    opt :blah, "Blah options", :short => '-b', :long => '--blah', :type => :flag
  end

  app.validations do |opts|
    opts.validate(:global_option, "must be either 'global' or 'local'") { |option| ["global", "local"].include?(option) }
  end

  app.action do |global_options, arguments, config|
    puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}\nuser config data: #{config}"
    #puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}"
  end
end

#config file is loaded automatically if it exists by walking up the directory tree when config file is specified DONE
#values from config file are merged into the parser correctly for global DONE
#values from config file are correctly overriden by those provided on the command line DONE
#values from config file get validated correctly DONE
#values from config file are merged into the parser correctly for commands DONE
#user config data can be passed through to action handling code DONE
#
#config file automatically gets created in user home directory when autocreate is true
#when config file is automatically created all the global and command options get put in there with default values
#when option --config get specified the provided config file is loaded as the default config file then execution continues
#when option --create-default-config is specified and autocreate is false a default config file is created, if it doesn't exist yet, before being read and execution continues
#when option --create-config is specified a config file with that name and default values is created, if it doesn't exit yet, before being read and execution continues
#another global option needs to be created to allow user to set it to be notified which config file if any is being used for this session

#app.rb --create-config = './yaddarc'
#app.rb --config = './yaddarc'

  #- ability to switch on and off default creation of config file X
  #- an option to read specific config file instead of the default X
  #- a flag to create a default config in a specific directory X
  #- the ability to by default read a config file by walking up the directory tree X
  #- config file options should be validated just like the command line options ??
  #- ability to configure global options and command specific options (through the file) ??
  #- ability to configure extra user data that may be needed (through the file) ??
#how will we pass the user level configuration up to handling code???

#by default no configuration file at all DONE
#if config_file was configured on the app DONE
  # the app gets a global --config options which takes a path of file to use as configuration file
  # the app gets a global --create-config which can have a path passed to it which will mean it creates a file with that name
  # the app gets a global --create-default-config option which is a flag meaning it will create a file in home director with default name
#if config_file specified and auto_create false DONE
  #program will attempt to look for file by walking up the directory tree on every invocation DONE
  #but file never gets automatically created DONE
#if config_file specified and auto_create true
  #program will attempt to look for file by walking up the directory tree on every invocation
  #if it doesn't exist when app is run then file gets created with some default values in the user home directory
#autoloading only works with files that are default named if custom named config file is created either manually or through --create-config then you can only used it via the --config global option, this is obvious
#creating a default named config file via --create-config without passing in a path will allow you to run the script from that directory and have that file picked up in preference to anyother config file lower down in the directory tree (e.g. in the home directory), this way you can have the script installed globally and run it from different directories with different default options
#config file format will be json:
#{
  #:global_options => {
  #},
  #:command_options => {
    #:my_command => {
    #},
    #:blah_command => {
    #}
  #},
  #:user_data => {
  #}
#}
#need to validate the options parts of the config file to make sure there is no rubbish in there
