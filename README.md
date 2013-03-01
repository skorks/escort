[![Build Status](https://travis-ci.org/skorks/escort.png)](https://travis-ci.org/skorks/escort)

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
* You can mark options as depending on each other (NOT YET IMPLEMENTED)
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
* Envrionment aware configuration (NOT YET IMPLEMENTED)
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

If you use the negation, the value of `:option1` in the command hash will be `false`, otherwise it will be `true`. Since we made `true` the default value, even if you don't specify the option at all, `:option1` will be `true`.

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


### Validations
TODO

### Configuration File
TODO

### Commands
TODO

### Sub-Commands
TODO

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
