# Escort

Basically we take the excellent Trollop command line options parser and dress it up a little with some DSL to make writing CLI apps a bit nicer, but still retain the full power of the awesome Trollop.

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
- a convention for how to do validation of various command line options (and validation in general)
- a convention for how to actually do the code that will handle the commands etc.
- support for configuration files for your command line apps
- how to preoperly do logging and support various modes (e.g. verbose)
- how to properly do exit codes and exception catching for the app
- creating a scaffold for a plain app without sub commands
- creating a scaffold for an app with sub commands
- better ways to create help text to override default trollop behaviour
- maybe add some specs for it if needed
- maybe add some cukes for it if needed
- ability to ask for user input for some commands, using highline or something like that
- support for infinitely nesting sub commands
- much better documentation and usage patterns
  - blog about what makes a good command line app (this and the one below are possibly one post)
  - blog about how to use escort and why the other libraries fall short
  - blog about how escort is constructed
  - blog about using escort to build a markov chains based name generator
  - blog about creating a sub command based app using escort
  - blog about creating an app with user input using escort


