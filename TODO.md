ROADMAP

v0.3.0
- test the configuration generator
- test the configuration merge tool
- test the configuration loader
- test the descend to home locator

- readme a basic app with config file, integration test (don't worry about explaining all the helper stuff that gets created)
- readme a command app with options, validations, description, summary, require arguments and config file, integration tests for commands, example
- BUG parent_options when parent of command is global context doesn't seem to work???
- test the base command for actions well
- up the version to 0.3.0
- tag and release


- test all the locators (descend, specfic dir, current script dir, chaining) DONE
- we should always be using the chaining locator, with more or less sub locators depending on setup DONE
- create other locators (dir of currently executing script locator, i.e. not the working directory, specified dir locator) DONE
- create a chaining locator so we can put all our locators together  DONE
- test the configuration reader DONE
- test the configuration writer  DONE
- a basic app example with all the trimmings DONE
- app with config file example     DONE
- readme implementing and action for a basic app DONE
- rejig for betterness the validations help outputs DONE
- test the string grid      DONE
- start using the new stream output formatter   DONE
- refactor terminal formatter and test it     DONE
- finish testing the output formatter        DONE
- get rid of shell command executor new shell stuff (doesn't work in Jruby and not really needed anyway)  DONE
- extract all the dsl command stuff into a helper module so that global and command can be handled by the same code DONE

v0.4.0
- readme for requires arguments overriding and inheritance
- readme explain all the helper stuff that automatically gets created with config file support
- test all the config file helper stuff
- readme a sub command app with options, validations, description, summary, require arguments and config file, integration tests, example
- fix ppjson so that dependency suport feature is actually used
- delete the stuff from the attic once it is no longer needed
- a few more tests (setup accessor, all the dsl classes)
- up the version to 0.4.0
- tag and release


v1.0.0
- have a think about how to make the integration tests a bit more robust, so that failures don't get swallowed (test for specific exit codes instead of non-zero exit code), fix the existing integration tests
- a few more integration tests (test that basic app automatically gets help and other automatic options)
- clean up all the extraneous branches
- up the version to 1.0.0
- tag and release
- get the blog updated with a new theme
- put a new subscriber count widget on blog
- blog Build Command-Line Apps Like a Pro Using Ruby and Escort


- in trollop when errors are raised they should be wrapped as escort errors and propagate rather than being caught by trollop itself DONE
- rework the examples again to show of some/most of the features (along the lines of the integration tests and readme)  DONE
- errors coming straigh out of configuration should still be caught by error handlers to only display stack trace when needed (refactor app create method) DONE
- readme for a basic app with conflicting options    DONE
- readme for a basic app with dependent options      DONE

v1.0.1
- add a section to readme for command line tools built with escort (e.g. ppjson)
- more specs
- more integration specs (more specs for the different types of options)
- a way have helpers available when you don't want to have to create a command
- the config auto option should not be included in the config file, same with other auto options
- readme about how to actually pass the user config through to action and the fact that regardless if you have a config file or not, you can have a config var or not as part of the block variables


- rework the integration specs and matchers so there are less moving parts (perhaps push some stuff down into a base class etc.) DONE
- rewrite the help formatter to be a bit easier to understand (more like man output for output) DONE
- add depends support to dsl   DONE

v1.0.2
- more specs
- need a suite for escort itself using escort to bootstrap etc
- scaffold for app with no sub commands
- scaffold for app with one level of commands
- scaffold for app with nested sub commands

v1.0.3
- refactor the app class so it is a bit nicer etc
- an option for setup that indicates it is a project specific CLI app
- an options for setup that indicates it is an environment aware CLI app
- make the configuration environment aware
- make escort environment aware (app.environment_aware)
- json configuration should support defaults config
- much better documentation and usage patterns
- pull the terminal formatting stuff into separate gem
- pull nested exception stuff into separate gem

v2.0.0
- rework actions with passing a class and having it being auto called
- implement servants for dealing with clumps of functionality, and action commands have access to all servants that were executed before them
- ability to break up a big config into chucks, e.g. per command etc. so that it is more modular and easier to read
- whether or not action is specified things should not blow up

v2.0.1
- lots more logging at different levels for debug purposes



BUCKET
- configatron support in addition to json config
- for help current command context is all confused, is the context a parent context or the current context, fixed in help but the class is still confused as it's being used in two different ways
- genericise the generator concept, so that the current one becomes a nested generator, but we can also have a flat generator
- genericise the writer and reader, so that the current one becomes json writer/reader, but we can have yaml or whatever we want
- we should always be working with a nested hash for configuration, its only at writing and reading time do we flatten or whatever
- dependencies for command options on options from parent commands or global
- a better way of executing action and servants for the actions

  - specify the options via classes
    #command.action StreamProvider::Commands::StopServer
  - define servants for actions within context
    #app.before_action :stop, :start, :restart do |action|
      #action.servant :configatron, StreamProvider::Servants::ConfigatronServant
    #end

    #app.before_action :restart do |action|
      #action.servant :blah, StreamProvider::Servants::BlahServant
    #end
  - a before action without command names in context
    app.before :actions => :this - only action in current context
    app.before :actions => :child - only child action in current context
    app.before :actions => [:this, :child] - this action and child actions
    app.before :actions => :descendant - all actions that descend from this one, but not this one

- can split out the shell command executor into a tiny gem for later use
- for borderless table, should be able to create another borderless table within a cell of an existing table
- get the build working on ruby 1.8.7
- formatting code should support colours and styles for output
- formatting code should support a table with borders and stuff
- formatting code should support a simple progress bar for showing progress
- formatting code should be more well factored
- highline support should be added so that values can be asked for
- values should be asked for before validations are executed, since entered values should be validated
- instead of before and after blocks, add before, after filters for commands, maybe
- when no action found in the context we want to execute, it should error or at least print an error
- can we flatten the configuration (as an option)
- can we extract the json configuration stuff into a separate gem
- json configuration should support having environment configs in multiple files
- blog the crap out of all aspects of how to use it, how it is constructed, some fancy things you can do with it etc.
- ability to ask for user input for a command (e.g. for passwords, this can possibly be done via validations)

- blog about what makes a good command line app (this and the one below are possibly one post)
- blog about how to use escort and why the other libraries possibly fall short
- blog about how escort is constructed
- blog about using escort to build a markov chains based name generator
- blog about creating a sub command based app using escort
- blog about creating an app with user input using escort
- blog about instance_eval and the fact that it doesn't do closure properly (why), and the trick from trollop for how to get it to accept arguments
- blog about exception hierarchy for apps, what exceptions to have, when to raise exceptions, touch on throw/catch and why they are bad/good, touch on exit codes for command line apps in the context of exception throwing
- blog about nested exceptions and how to make them nice in your app, also metion exceptional ruby book as well as nestegg gem
- blog about dependencies with bundler, the spermy operator and what version will be chosen
- blog about ppjson and how to use it

- improve the terminal formatter, allowing wrapping text to anywhere, and tabular like output without an actual table, allowing configuring terminal of any size not just 80, spin it off a little separate project, with an example of how to possibly build a menu in it or something DONE
- BUG the help formatting is still not quite right as far as respecting the char limits and wrapping properly when doing tabular output!!!! DONE
- do a readme for how trollop was slightly modified to accept a formatter
- gemspec summary and description should be taken from the app definition/maybe
- perhaps add a copyright with license to readme
- via method missing we can make the dsl classes more robust by printing errors and exting when non-dsl methods are attempted
- configuring multi of multi
- how do we describe what the arguments should be??
- blog about the convention for implementing the escort actions
- ability to provide some default command line arguments via an environment variable


PIE IN SKY
- choosing default output format based on where the output is going STDOUT.tty?
- look at ruby curses support a bit more closely and maybe use that for terminal stuff instead as it would be much better at it
- a library for specifying conditions and matching on those conditions
- possible syntax for conditions library:
  Conditions.new do
   _and do
      _= a, 1
      _not do
        _or do
          _nil :b
          _empty :b
          _false :b
        end
      end
      _present :b
      _present [:c, :d]
      _nil :e
      _empty :f
      _false :g
      _or do
        _= :h, 5
        _and do
          _= :i, 7
          _empty :j
        end
      end
    end
  end



DONE
- create a tool to pretty print json (ppjson) using escort
- global config param if config file
- if app has a config, then give another param to control the extras creation, which will be an 'escort' sub command to allow manually creating and updating the config file etc.
- do all the other config file bits such as creating default, non-default and updating etc.
- catching all exceptions and dealing with them in a better way
- global verbose param always
- a global logger for escort which is accessible to commands etc.
- support an on_error block to allow user to control what happens when errors occur
- default option values via env variables (if necessary)
- instead of exiting and printing errors all over the place, just raise specific errors, and handle the printing and exiting in the handle block in app.rb
- options that are added by the system and not by the user should come at the end of the options list not sprinkled everywhere in help
- test the configuration loading and writing again
- get the coniguration updating working (two hashes should be merged, values both in hash1 and hash2 should be left alone, values in hash1, but not in hash2 should be deleted from hash1, values in hash2 but not in hash1 should be added to hash1)
- support for configuration files for your command line apps DONE
- the ability to set the config file name DONE
- ability to switch on and off default creation of config file DONE
- the ability to by default read a config file by walking up the directory tree DONE
- ability to configure global options and command specific options (through the file) DONE
- ability to configure extra user data that may be needed (through the file) DONE
- an option to read specific config file instead of the default DONE
- a flag to create a default config in a specific directory DONE
- config file options should be validated just like the command line options DONE
- configuring array :multi data via the configuration file DONE
- exception hierarchy for gem and better exit codes (better exception handling for the whole gem, UserError, LogicErrors(InternalError, ClientError), TransientError, no raise library api, tagging exceptions) DONE
- do a readme entry on exception handling and exit codes DONE
- provide version via configuration DONE
- automatically include version (not just version, automatically include commands in general) DONE
- better ways to create help text to override default trollop behaviour (use below as a default) DONE
- add default values to help text DONE
- refactor so that objects passed into the dsl only have dsl methods available to call DONE
- better support for before and after blocks with explanations and examples of usage N/A
- better support for on_error blocks with explanations and examples of usage (roll exit code support into here), default handling of errors in block N/A
- a convention for how to actually do the code that will handle the commands etc. DONE
- support for infinitely nesting sub commands (is this really necessary) DONE

v0.1.0
- some spec infrastructure                                                          DONE
- a couple of basic specs                                                           DONE
- some integration test infrastructure                                              DONE
- a couple of basic integration tests                                               DONE
- pull classes for formatting out into files                                        DONE
- summary and description for commands                                              DONE
- include command summary and description in help formatter                         DONE
- rework how help is displayed for commands with summary and description            DONE
- the sub commands for command should use summary instead of description            DONE
- do for validation and action what I did for option within the dsl                 DONE
- look again at conflicts support in dsl, we can probably do better naming for it   DONE
- up the version to 0.1.0                                                           DONE
- tag and release                                                                   DONE

v0.2.0
- up the version to 0.2.0 DONE
- tag and release DONE
- test conflicts for non-exstant options (integration) DONE
- test all the new help stuff on option, for conflicts, dependencies, validations DONE
- fix up readme for conflicts block    DONE
- rework validations to be part of the options block rather than in their own block  DONE
- fix example, fix tests, fix readme DONE
- need to rework conflicts as currently not really very good   DONE
- add dependencies to help text  DONE
- add conflicts to help text     DONE
- add validation texts to help text so that people can see what kind of values are valid  DONE
- make sure we check conflicts for non-existant options   DONE
- refactor the formatting code some more DONE
- pull some formatting code into separate classes DONE
- test some of the utility formatting code DONE
- fix up help text so that if arguments are mandatory they are shown as mandatory not optional DONE
- basic example with validations       DONE
- integration test for validations     DONE
- readme for validations               DONE
- test the shell command executor, and the terminal class for width command DONE
- improve the readme to explain
  - a basic app with no options                                 DONE
  - a basic app with options                                    DONE
    - supplying multiple of the same parameter using multi      DONE
  - a basic app with require arguments                          DONE
  - a basic app specifying version, description and summary     DONE
  - test the readme for flags to make sure it works as expected DONE
  - a basic app with dependant options (mention that a deadlock situation can occur if you're not careful)  DONE
- example for conflicting options                            DONE
- integration test for conflicting options                   DONE
- readme for conflicting options                             DONE
- for print stacktrace, change it to print in INFO mode so that stacktrace not printed by default DONE
- BUG when a script requires arguments and user doesn't supply any escort treats this as an internal error and asks you to report it, this shouldn't be the case DONE
- depends_on support
  - option depends on flag                                                                      DONE
  - flag depends on another flag                                                                DONE
  - one option depends on another (the other must be not false not nil and not empty)           DONE
  - one option depends on specific value of another (the other must be of a specific values)    DONE
  - one option depends on several others (where are must be not false not nil and not empty)    DONE
  - one option depends on several others where some must have a specific value (some options have specific value, others are not false not nil and not empty)  DONE
  - error if option for which dependecy is being defined does not exist                         DONE
  - error if depends on non-existant option                                                     DONE
  - error if depends on itself                                                                  DONE
  - error if dependency not satisfied                                                           DONE
  - error if missing on condition when specifying dependency                                    DONE
  - refactor the options dsl class dependency code                                              DONE
  - refactor the option_dependency_validator class to be nicer                                          DONE
  - integration test all the permutations of dependency specification with error and success cases etc  DONE
  - create a shortcut for dependency specification on the opt method options hash itself                DONE
  - fix up example for basic app with dependencies for options                                          DONE
