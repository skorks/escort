[![Build Status](https://travis-ci.org/skorks/escort.png?branch=master)](https://travis-ci.org/skorks/escort)

# Escort

Writing even complex command-line apps should be quick, easy and fun. Escort takes the excellent [Trollop](http://trollop.rubyforge.org/) option parser and adds a whole bunch of awesome features to produce a library you will always want to turn to when a 'quick script' is in order.

## Why Write Another CLI Tool

A lot of the existing CLI making libraries delegate to OptionParser for actually parsing the option string, while OptionParser is nice it doesn't allow things like specifying the same option multiple times (e.g. like CURL -H parameter) which I like and use quite often. Trollop handles this case nicely, so a Trollop-based CLI tool is superior.

Also a lot of the other CLI libraries in an attempt to be extra terse and DRY make their syntax a little obtuse. Escort tries to create a DSL that strikes a balance between being terse and being easy to understand, remember and read.

I find that I end up with a similar structure for the CLI apps that I write and I want to capture that as a bit of a convention/pattern. An app doesn't stop at the option parsing, how do you actually structure the code that executes the work?

In general, some libraries give you great option parsing, but no infinitely nesting sub-command, others have sub-commands, but the option parsing is inferior. I want everything from my CLI library, without having to dig through feature lists, trying to figure out what will give me the biggest bang for my buck.

## Features

* Long and short form options (e.g. `-g` and `--global`)
* Command support (e.g. `my_app do` - where `do` is a command)
* Infinitely nesting sub-command support (e.g. `my_app do something fun` - where `do`, `something` and `fun` are commands)
* Options on a per command and sub-command level (e.g. `my_app -g do -g something -g fun` - where `-g` can mean different things for each command)
* Nicely formatted help text (your app get `-h` and `--help` options automatically)
* Version support (your app can get the `-v` and `--version` based on specification)
* Multi options (e.g. `my_app -x foo -x bar -x baz`)
* You can mark options as conflicting with each other
* You can mark options as depending on each other
* Declarative validation support for each option, with multiple validation rules per option
* Specify script arguments as required or optional (when arguments are required `my_app -g foo` will execute, but `my_app -g` will prompt the user to enter arguments)
* Specify summary and description for your script as well as per command or sub-command
* A pattern for executing command actions (e.g. a base class to inherit from, with many helper methods)
* Automatic option to up the verbosity level of output, for debugging purposes
* Sensible and robust error handling, that distinguishes between library issues and implementation errors
* Config file support (e.g. `.my_apprc`), JSON format, created in user home directory by default
  * Set up config files to be auto-creatable
  * Built in config file discovery by walking up the directory tree
  * Automatic option to supply a specific config file for current run
  * Config file values can override default values
  * Command line options can override config file values
  * A space for user specific config values in the config file, which is available at runtime
  * Automatic command with options to update and create config files in a default location or anywhere else (e.g. `my_app escort --update-config`)
* Tool to bootstrap an Escort script (basic, with commands and with sub-commands)  (NOT YET IMPLEMENTED)
* Environment aware configuration (NOT YET IMPLEMENTED)
* Project specific scripts support (NOT YET IMPLEMENTED)
* Lots of usage examples (COMING SOON)
* Lots of documentation (COMING SOON)

## Installation

Add this line to your application's Gemfile:

    gem 'escort'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escort

## Usage

Let's say you want to do a basic app. As long as `escort` is installed as a gem, you might do something like this:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

If your script is called `app.rb` you is executable, you can then call it like this:

```
./app.rb
./app.rb --help
```
And it will run whatever code you have in the execute method of your `ExampleCommand`. The command should inherit from `::Escort::ActionCommand::Base` which will give it access to things like `options`, `arguments`, `command_options`, `config` etc.

Of course the above configuration didn't let us specify any options (except for `--help`), so lets add some.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```
We can now do:

```
./app.rb -o blah
./app.rb --option1=blah
```

Now when your command is being executed and passed the option through on the command-line, the `command_options` hash will contain the value keyed on the canonical name of your option `:option1`.

### Multi Options

Creating an option that can be specified multiple times is dead simple:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
    opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

We can now do:

```
./app.rb --option2=hello --option2=world
```

Notice that the short form for the multi option was disabled so we had to use the long form, we could, of course create a short form for this option as well.

The `command_options` hash in our `ExampleCommand` will have an array of values for multi options.

### Flags

Flags are easy, just decalre an option as a `:boolean` and you can use it as a flag and will automatically gain a negation for it as well. For example:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :boolean, :default => true
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

We can now do:

```
./app.rb -h
./app.rb -o
./app.rb --option1
./app.rb --no-option1
```

If you use the negation, the value of `:option1` in the command hash will be `false`, otherwise it will be `true`. Since we made `true` the default value, even if you don't specify the option at all, `:option1` will be `true`. If you don't set the default for a flag to `true`, then it will have no negation, since not using the flag will be equivalent to setting to `false`.

### Required Arguments

When you define an Escort app, by default it will not require you to supply any arguments to it. However you can specify that arguments are required for this app.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.requires_arguments

  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
    opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

We can now do:

```
./app.rb -o foo --option2=bar argument1
```

This will execute fine, but if we do:

```
./app.rb -o foo --option2=bar
```

The app will prompt the user to enter an argument. Pressing `Enter` will allow to enter more arguments. Like with many command-line apps you will need to press `Ctrl-D` to jump out of the prompt and allow the app to execute.

There is one extra thing to note. If you're writing a command suite (see below for explanation). The `requires_arguments` setting will be inherited by all the sub-commands. You can however easily override the setting for any sub-command and this overridden value will be inherited by all the sub-commands of that command.

```ruby
...
  app.command :start do |command|
    command.requires_arguments false

    command.action do |options, arguments|
      MyApp::ExampleCommand.new(options, arguments).execute
    end
  end
...
```

This way different commands in your app can pick and choose whether or not they want to require arguments or make them optional.


### Better Help Text

You automatically get some nicely formatted help text for your app. But to make the help a bit nicer, make sure you specify a summary and description.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.version "0.1.1"
  app.summary "Summary 1"
  app.description "Description 1"

  app.requires_arguments

  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
    opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

Your help text will then look like this:

```
NAME
    app.rb - Summary 1

    Description 1

USAGE
    app.rb [options] [arguments...]

VERSION
    0.1.1

OPTIONS
    --option1, -o <s>         - Option1 (default: option 1)
    --option2 <s>             - Option2
    --verbosity <s>           - Verbosity level of output for current execution (e.g. INFO, DEBUG) (default: WARN)
    --error-output-format <s> - The format to use when outputting errors (e.g. basic, advanced) (default: basic)
    --version, -v             - Print version and exit
    --help, -h                - Show this message
```

As you can see we've also specified the version, which gives us the `--version` flag.

### Option Dependencies

You can set up some options to be dependent on the presence or absence of other options. The app will not execute successfully unless all the dependencies are met. You can make your dependencies quite complex, but it is best to keep it pretty simple.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
    opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean, :default => true
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string
    opts.opt :option2, "Option2", :short => :none, :long => '--option2', :type => :string, :multi => true
    opts.opt :option3, "Option3", :short => :none, :long => '--option3', :type => :string
    opts.opt :option4, "Option4", :short => :none, :long => '--option4', :type => :string

    opts.dependency :option1, :on => :flag1
    opts.dependency :option2, :on => [:flag1, :option1]
    opts.dependency :option3, :on => {:option1 => 'foo'}
    #opts.dependency :option4, :on => [{:flag1 => false}, :option1] #This will get you into big trouble as it can never be fulfilled
    opts.dependency :option4, :on => [{:flag2 => false}, :option1]
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

In this case if you're using `:option1` you need to have `:flag1` as well e.g.:

```
./app.rb -o foo -f
```

`:option2` requires both `:option1` and `:flag1` (of course since `:option1` already has a dependency on `:flag1` it is bit redundant, but demostrates the syntax).

`:option3` is dependant on `:option1` having a particular value, so we need to have:

```
./app.rb -o foo -f --option3=bar
```

in order for the app to execute successfully, when we've specified `:option3` on the command-line.

Note how with `:option4` we can mix the syntax. However also note the commented out dependency, this is how you can get into trouble if you make your dependencies too complex. `:option4` in the comment requires `:option1` and the absence of `:flag1`, but `:option1` requires `:flag1` to be present. Needless to say with that specification, using `:option4` on the command-line will never allow the app to execute successfully.


### Option Conflicts

You can specify 2 or more option as conflicting, which means the app will not execute successfully if more than one of those options are provided on the command-line together.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :flag1, "Flag 1", :short => '-f', :long => '--flag1', :type => :boolean
    opts.opt :flag2, "Flag 2", :short => :none, :long => '--flag2', :type => :boolean

    opts.conflict :flag1, :flag2, :flag3
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

This will succeed:

```
./app.rb --flag1
```

This will fail:

```
./app.rb --flag1 --flag2
```

Simple!


### Validations

Validations are pretty easy, they can be defined inside the options block. You must provide an option symbol and an error message for when validation fails. The actual validation is a block, when the block evaluates to true, it means validation is successful, otherwise validation fails. That's all there is to it.

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.options do |opts|
    opts.opt :option1, "Option 1", :short => '-o', :long => '--option1', :type => :string
    opts.opt :int1, "Int 1", :short => '-i', :long => '--int1', :type => :int
    opts.opt :option2, "Option 2", :short => :none, :long => '--option2', :type => :string

    opts.validate(:option1, "must be either 'foo' or 'bar'") { |option| ["foo", "bar"].include?(option) }
    opts.validate(:int1, "must be between 10 and 20 exclusive") { |option| option > 10 && option < 20 }
    opts.validate(:option2, "must be two words") {|option| option =~ /\w\s\w/}
    opts.validate(:option2, "must be at least 20 characters long") {|option| option.length >= 20}
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

In this case running:

```
./app.rb -o baz
```

will produce:

```
option1 must be either 'foo' or 'bar'
```

But if you run:

```
./app.rb -o bar
```

Everything will work fine.

As you can see you may define multiple validation rules for the same option without any issues, all will need to pass for the app to execute successfully.


### Configuration File

Sometime you have a whole bunch of command line options you need to pass in to your app, but the value of these options hardly ever changes. It's a bit of a drag to have supply these on the command-line every time. This is why we have config file support. You may indicate that your app has a config file like so:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.config_file ".my_apprc", :autocreate => true

  app.options do |opts|
    opts.opt :option1, "Option1", :short => '-o', :long => '--option1', :type => :string, :default => "option 1"
  end

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end
end
```

Essentially we give the config file a name and optionally set the config file to be autocreatable. When the config file is autocreatable, the first time you run the command-line app, a config file with the name your specified will be created in the default location (which is your home directory). The config file format is JSON, and it is structured in a specific way to support infinitely nesting sub commands. The config file for an app like the one above, might look like this:

```
{
  "global": {
    "options": {
      "option1": "option 1",
      "config": null,
      "verbosity": "WARN",
      "error_output_format": "basic"
    },
    "commands": {
      "escort": {
        "options": {
          "create_config": null,
          "create_default_config": null,
          "update_config": null,
          "update_default_config": null
        },
        "commands": {
        }
      }
    }
  },
  "user": {
  }
}
```

All the options you can supply to your app will be present in the config file as well as all the commands and all their options etc (you also get a bunch of options and a single command that get automatically added by escort for your convenience, these will be explained below). You can go and modify the values for all your options in the config file. The config file values, take precedence over the default values that you specified for the options (if any), but if you supply an option value on the command-line, this will still take precedence over the option value you define in the config file. This way you can provide sensible defaults and still override when necessary.

Whenever you define an app to have a config file, escort will add some utility options and commands for you to make working with config files easier. Firstly, you will get a global `config` option. This can be used to make your app take a specific config file instead of the default one, this config file will only be valid for the single execution of your command-line app e.g.:

```
./app.rb --config='/var/opt/.blahrc' -o yadda
```

You also get a utility command for working with config files - the `escort` command. This command has 4 options:

* `--create-config` - this can be used to create a config file in a specified location
* `--create-default-config` - this can be used to create a config file in the default location (home directory) if one doesn't already exit
* `--update-config` - this can be used to update a specific config file (mainly useful during development), if you've added new options/commands using this option will allow your config file to reflect this (it will not blow away any of the values you have set for your options)
* `--update-default-config` - same as above but will just work with the default config file if it is present (if not, it will create a default config file)

These utility options can be very useful as the nested format of the config file can become confusing if you have to update it by hand with new options and commands while you're developing your apps.

It is also worth knowing that Escort is quite clever when it comes to working out which config file to use for a particular run of the command-line app. It will not just use the config file in your home directory, but will instead attempt to find a config file closer in the directory hierarchy to the location of the command-line script. The strategy is as follows:

* look for a config file in the directory where the command-line script itself lives, if found use that one
* otherwise look for a config file in the current working directory and use that one
* if still not found, go down one level of the directory tree from the current working directory and look for a config file there
* keep going down the directory tree until the home directory is reached, if no config file was found, then no config file exists
* in which case either create the config file in home directory (if autocreatable) or continue without config file

As you can see the config file support is quite extensive and can take your command-line apps to the next level in terms of usability and utility.


### Command Suites

You're not just limited to options for your command-line apps. Escort allows you to turn your command-line apps into command-line suites, with command support. Let's say you want a command-line app to control a process of some sort. Your process is `app.rb`. What you want to be able to do is the following:

```
./app.rb start
./app.rb stop
./app.rb restart
```

You also want to be able to provide options both to the main process itself as well as to the various commands, e.g.:

```
./app.rb -e production start --reload
```

Escort makes this easy:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.config_file ".my_apprc", :autocreate => true

  app.options do |opts|
    opts.opt :environment, "Environment", :short => '-e', :long => '--environment', :type => :string, :default => "development"
  end

  app.command :start do |command|
    command.summary "Start process"
    command.description "Start process"

    command.options do |opts|
      opts.opt :reload, "Reload", :short => '-r', :long => '--reload', :type => :flag
    end

    command.action do |options, arguments|
      MyApp::ExampleCommand.new(options, arguments).execute
    end
  end

  app.command :stop do |command|
    command.summary "Stop process"
    command.description "Stop process"

    command.action do |options, arguments|
      MyApp::ExampleCommand.new(options, arguments).execute
    end
  end

  app.command :restart do |command|
    command.summary "Restart process"
    command.description "Restart process"

    command.action do |options, arguments|
      MyApp::ExampleCommand.new(options, arguments).execute
    end
  end
end
```

Of course you would probably use a different `ActionCommand` class to implement each of your defined commands (more on `ActionCommands` below).


### Command Suites Sub-Commands

Of course if one level of commands is good it is only logical that multiple levels of commands is even better. Luckily Escort supports infinitely nesting sub-commands so you can create command-line suites which are truly extensive. Let's say you're writing a command-line utility for your framework, you've named your framework 'Rails' (cause surely that's not taken :P) and your utility is `rails`. You want your utility to be used for generating migrations as well as controllers, something like:

```
rails generate migration
rails g controller
```

Of course you want to be able to supply a set of options to each of the sub-commands when necessary:

```
rails -e development generate migration --sequel
```

As we've come to expect, this is very easy:

```ruby
#!/usr/bin/env ruby

require 'escort'
require 'my_app'

Escort::App.create do |app|
  app.config_file ".my_apprc", :autocreate => false

  app.options do |opts|
    opts.opt :environment, "Environment", :short => '-e', :long => '--environment', :type => :string, :default => "development"
  end

  app.command :generate, :aliases => [:g] do |command|
    command.command :migration do |command|
      app.options do |opts|
        opts.opt :sequel, "Sequel", :short => '-s', :long => '--sequel', :type => :flag
      end

      command.action do |options, arguments|
        MyApp::ExampleCommand.new(options, arguments).execute
      end
    end

    command.command :controller do |command|
      command.action do |options, arguments|
        MyApp::ExampleCommand.new(options, arguments).execute
      end
    end
  end
end
```

Of course, you can flesh it out by providing a summary and description for the commands, specifying if arguments are required, conflicts, dependencies etc (this will be reflected in the help text). Just about everything you can do at the global level for apps without sub-commands, you can do at the command level (the only things you currently can't specify at the command level are 'version' and 'config_file', these are global only).


### Implementing the Actions

So far we've seen a lot of examples of how to add various command-line UI features, but what about implementing the actual functionality.

If your functionality is a one liner, you can, of course, just dump it into the action block, but we're trying to keep a clean separation between our UI logic and the actual functionality we are trying to implement. We do this by writing `ActionCommand` classes.

In all the previous examples you've seen the following:

```ruby
...

  app.action do |options, arguments|
    MyApp::ExampleCommand.new(options, arguments).execute
  end

...
```

The `ExampleCommand` is an `ActionCommand` and is implemented in a separate class. In the above examples we would `require 'my_app'` with the assumption that it requires the file where `ExampleCommand` is implemented. You could of course just require the file with the implementation directly.

A command might look like this:

```ruby
module Escort
  class ExampleCommand < ::Escort::ActionCommand::Base
    def execute
      Escort::Logger.output.puts "Command: #{command_name}"
      Escort::Logger.output.puts "Options: #{options}"
      Escort::Logger.output.puts "Command options: #{command_options}"
      Escort::Logger.output.puts "Arguments: #{arguments}"
      if config
        Escort::Logger.output.puts "User config: #{config}"
      end
    end
  end
end
```

As you can see all you need to do is inherit from `::Escort::ActionCommand::Base` and implement the execute method. Inheriting from `Base` gives you access to a bunch of useful methods:

* `command_name` - the name of the command that is being executed (or :global if it is the main action)
* `command_options` - the options for this command
* `parent_options` - the options for the parent command (if any)
* `global_options` - the global app options
* `config` - a hash of the user defined portion of the configuration file
* `options` - the raw options hash
* `arguments` - a list of arguments passed to the app

These should give you hand in implementing the functionality you need, but most importantly it allows us to keep our actual command-line UI definition clean and separate the useful logic into what is/are essentially pure ruby classes.

## Examples

There is an examples directory where you can have a play with a whole bunch of little 'Escort' apps, from a very basic one with no options to more complex nested command suites with all the trimmings. Most of them call the `ExampleCommand` which lives in `examples/commands`. Have a read/play to learn, or just copy/paste bits straight into your apps.

## More In-Depth

TODO

## Command-Line Tools Built With Escort

If you've used Escort to build a command-line tool that you have made publicly available, feel free to add a link to it here.

* https://github.com/skorks/ppjson - pretty print your JSON on the command-line (works with JSON strings as well as files containing JSON, can uglify as well as pretty print)


## Alternatives

* https://github.com/davetron5000/gli
* https://github.com/visionmedia/commander
* https://github.com/ddfreyne/cri
* https://github.com/ahoward/main
* https://github.com/wycats/thor
* https://github.com/injekt/slop

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
