# Escort

Basically we take the excellent [Trollop](http://trollop.rubyforge.org/) command line options parser and dress it up a little with some DSL to make writing CLI apps a bit nicer, but still retain the full power of the awesome Trollop.

## Why Write Another CLI Tool

A lot of the existing CLI making libraries delegate to OptionParser for actually parsing the option string, while OptionParser is nice it doesn't allow things like specifying the same option multiple times (e.g. like CURL -H parameter) which I like and use quite often. Trollop handles this case nicely.

Also a lot of the other CLI libraries in an attempt to be extra terse and DRY make their syntax a little obtuse, Trollop on the other hand, is not overly DRY, the syntax is simple and easy to understand, it just needed a little DSL to make a command line app built with it nice looking.

Also I find that I end up with a similar structure for the CLI apps that I write and I want to capture that as a bit of a convention. An app doesn't stop at the option parsing, how do you actually structure the code that executes the work.

There is a bunch of other minor reasons, so there you have it.

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

Escort::App.create do |app|
  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :multi_option, "Option that can be specified multiple times", :short => '-m', :long => '--multi', :type => :string, :multi => true
  end

  app.action do |global_options, arguments|
    puts "Action for my_command\nglobal options: #{global_options} \narguments: #{arguments}"
  end
end
```

If your file is called `app.rb` you is executable, you can then call it like this:

```
./app.rb
./app.rb -h
./app.rb -g "hello"
./app.rb -m "foo" -m "bar" --global="yadda"
```

You can have a play with it under `examples/basic`. How about something a bit more complex. Let's say we want to do an app with sub commands. Our `app.rb` file might look like this:

```ruby
#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.command :my_command do |command|
    command.options do
      banner "Command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |global_options, command_options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end
end
```

Now you'll be able to do things like:

```
./app.rb --help
./app.rb my_command
./app.rb my_command foobar
./app.rb my_command --no-do-stuff foobar
./app.rb -g "blah" my_command --do-stuff foobar
```

You can have a play with it under `examples/sub_commands`.

Note that nesting sub commands is currently not supported, so you can have `./app.rb my_command --help`, but you can't have `./app.rb my_command my_sub_command --help`, this is not Inception you can't go deeper (I might support it in the future if I decide it's worth the trouble).

Also note that when specifying options, you MUST provide global options before the sub command and command options after, so in the above case, this is fine:

```
./app.rb -g "blah" my_command --do-stuff foobar
```

But this is not:

```
./app.rb my_command -g "blah" --do-stuff foobar
```

You will get an error as `-g` will not be recognised as an option.

### Specifying a Default Command

It is possible to do this, but will only come into effect is you didn't pass anything on the command line at all. If that is the case,
by default, you'll get the global help message i.e. if your script is named `my_script` calling `./my_script` is equivalent to calling `./my_script -h`. However you can override this like so:

```ruby
Escort::App.create do |app|
  ...
  app.default "-g 'local' my_command --no-do-stuff"
  ...
end

```

The above will make escort treat the string you passed to `default` as if it came from the command line, so if your script is named `my_script` calling `./my_script` would be equivalent to calling `./my_script -g 'local' my_command --no-do-stuff`.

There is an example to have a play with under `examples/default_command`. It is possible to specify a default for an app with or without sub commands.

### Validation

Some validation is already provided by [Trollop](http://trollop.rubyforge.org/) when you specify the options. Specifically, you specify the basic type so the fact that your option is an integer, a float, a string etc. will already be ensured. Also you may also specify that an option is required (via `:required => true`) which will produce an error if it wasn't supplied. For more complex things we have validation support. Here is an example:

```ruby
#!/usr/bin/env ruby
require File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "..", "lib", "escort"))

Escort::App.create do |app|
  app.options do
    banner "My script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opt :multi_option, "Option that can be specified multiple times", :short => '-m', :long => '--multi', :type => :string, :multi => true
    opt :a_number, "Do stuff", :short => "-n", :long => '--number', :type => :int
  end

  app.validations do |opts|
    opts.validate(:global_option, "must be either global or local") { |option| ["global", "local"].include?(option) }
    opts.validate(:a_number, "must be between 10 and 20 exclusive") { |option| option > 10 && option < 20 }
  end

  app.command :my_command do |command|
    command.options do
      banner "Command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
      opt :string_with_format, "String with format", :short => "-f", :long => '--format', :type => :string, :default => "blah yadda11111111111"
    end

    command.validations do |opts|
      opts.validate(:string_with_format, "should be two words") {|option| option =~ /\w\s\w/}
      opts.validate(:string_with_format, "should be at least 20 characters long") {|option| option.length >= 20}
    end

    command.action do |global_options, command_options, arguments|
      puts "Action for my_command\nglobal options: #{global_options} \ncommand options: #{command_options}\narguments: #{arguments}"
    end
  end
end

```

As you can see we can validate global and command level options using a separate `validations` call with a block. All you do is provide the identifier for the option and a message to print out if the validation wasn't fulfilled. The validation itself is performed by executing the supplied block which should evaluate to `true` for a successful validation. Since the block can contain arbitrary Ruby code the possibilities are pretty endless. If there is ever a need for much more complex validations it would be trivial to support providing a class as a validator, but for now I think the above is more than sufficient. You can provide multiple valiation rules for the same option in case you want to do fine grained validation messages.

In the above case if our script is called `app.rb` then doing the following:

```
./app.rb -g "blah" my_command --do-stuff foobar
```

Will produce an error message like this:

```
Error: argument --global must be either 'global' or 'local'.
Try --help for help.
```

The above example is under `examples/validation_basic`, so you can have a play.

## Alternatives

* [GLI](https://github.com/davetron5000/gli)
* [Commander](https:/github.com/visionmedia/commander)
* [CRI](https:/github.com/ddfreyne/cri)
* [main](https:/github.com/ahoward/main)
* [thor](https:/github.com/wycats/thor)
* [slop](https:/github.com/injekt/slop)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### TODO

- ability to support a command line app without sub commands DONE
- ability to have a default command DONE
- a convention for how to do validation of various command line options (and validation in general) DONE
  - validations for commands DONE
  - make sure it is more robust DONE
  - more examples DONE
  - update the readme to explain validations DONE
  - make it possible to define it on the option itself, although this pollutes the option somewhat so maybe not???? DONE
  - make multiple validations for the same option possible for finer grained validation messages DONE
  - make sure there is minimum code duplication DONE
- support for configuration files for your command line apps
- a convention for how to actually do the code that will handle the commands etc.
- how to preoperly do logging and support various modes (e.g. verbose)
- how to properly do exit codes and exception catching for the app
- better support for before and after blocks with explanations and examples of usage
- better support for on_error blocks with explanations and examples of usage (roll exit code support into here)
- better exception handling for the whole gem
- creating a scaffold for a plain app without sub commands
- creating a scaffold for an app with sub commands
- better ways to create help text to override default trollop behaviour
- maybe add some specs for it if needed (via aruba)
- ability to ask for user input for some commands, using highline or something like that (is this really necessary???, maybe for passwords)
- support for infinitely nesting sub commands (is this really necessary)
- much better documentation and usage patterns
  - blog about what makes a good command line app (this and the one below are possibly one post)
  - blog about how to use escort and why the other libraries possibly fall short
  - blog about how escort is constructed
  - blog about using escort to build a markov chains based name generator
  - blog about creating a sub command based app using escort
  - blog about creating an app with user input using escort


