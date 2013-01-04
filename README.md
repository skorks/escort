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

Really easy, here is an example:

```ruby
#!/usr/bin/env ruby
require 'escort'

Escort::App.create do |app|
  app.options do
    banner "my script banner"
    opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
  end

  app.command :my_command do |command|
    command.options do
      banner "Sub command"
      opt :do_stuff, "Do stuff", :short => :none, :long => '--do-stuff', :type => :boolean, :default => true
    end

    command.action do |global_options, command_options, arguments|
      #actually do the work for this command here
    end
  end

  app.before do |command_name, global_options, command_options, arguments|
    #executes before each command
  end

  app.on_error do |error|
    #handle all errors here
  end
end
```

That's all there is to it, now if your script is named `my_script` you'll be able to do things like:

```
my_script my_command
my_script my_command foobar
my_script my_command --no-do-stuff foobar
my_script -g "blah" my_command --do-stuff foobar
```

That is all for now, just some DSL around Trollop to make your script look nice (hopefully more nice things to come).

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

- should be able to support command line apps without sub commands, just a plain vanilla command line app
- should have the ability to generate a skeleton command line app according to my conventions
- should be more config file aware but can live without it
- work out if it needs to be involved in better logging support
- should have better ability to create better help text
- should have deal better with exit codes and stuff (read the book section about it)
- maybe add some specs for it if needed
- maybe add some cukes for it if needed
- blog about what makes a good command line app (this and the one below are possibly one post)
- blog about how to use escort and why the other libraries fall short
- blog about how escort is constructed
- should have ability to ask for user input for some commands, using highline or something like that
- should have a clean structure convention of where code that executes the commands should live so that command line apps are easy
- use escort to build a command line version of my markov chains name generator from ages ago
- blog about using escort to build my name generator
- ability to have a default command when you didn't specify one??? (what would this mean for sub command and non sub command apps)
