# Escort

Writing even complex command-line apps should be quick, easy and fun. Escort takes the excellent [Trollop](http://trollop.rubyforge.org/) option parser and adds a whole bunch of awesome features to produce a library you will always want to turn to when a 'quick script' is in order.

## Why Write Another CLI Tool

A lot of the existing CLI making libraries delegate to OptionParser for actually parsing the option string, while OptionParser is nice it doesn't allow things like specifying the same option multiple times (e.g. like CURL -H parameter) which I like and use quite often. Trollop handles this case nicely, so a Trollop-based CLI tool is slightly superior.

Also a lot of the other CLI libraries in an attempt to be extra terse and DRY make their syntax a little obtuse. Escort tries to create a DSL that strikes a balance between being terse and being easy to understand.

I find that I end up with a similar structure for the CLI apps that I write and I want to capture that as a bit of a convention. An app doesn't stop at the option parsing, how do you actually structure the code that executes the work?

In general, some liraries give you great option parsing, but no infinitely nesting sub command, others have sub commands, but the option parsing is inferior. I want everything out of my CLI library, without having to dig through feature lists trying to figure out what will give me the biggest bang for my buck.

## Features

TODO

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
  app.version "0.2.5"

  app.options do |opts|
    opts.opt :global_option, "Global option", :short => '-g', :long => '--global', :type => :string, :default => "global"
    opts.opt :multi_option, "Option that can be specified multiple times alksjdfh lakjdfh adf alksdfh alkdfjh alsdfjhaskdjfh alsdkfjh alksfdjh akdfjh alkdsjf alksdjfh alksdfjh asdfjklh aslkdfhj aslkdfjh adfjkhl", :short => '-m', :long => '--multi', :type => :string, :multi => true
  end

  app.action do |options, arguments|
    puts "Action \nglobal options: #{options} \narguments: #{arguments}"
  end
end
```

If your file is called `app.rb` you is executable, you can then call it like this:

```
./app.rb
./app.rb -h
./app.rb -g "hello" foobar
./app.rb -m "foo" -m "bar" --global="yadda" foobar
```

### Sub Commands

TODO

## Alternatives

* [GLI](/davetron5000/gli)
* [Commander](/visionmedia/commander)
* [CRI](/ddfreyne/cri)
* [main](/ahoward/main)
* [thor](/wycats/thor)
* [slop](/injekt/slop)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
