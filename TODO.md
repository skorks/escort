ROADMAP

v0.2.0
- BUG when a script requires arguments and user doesn't supply any escort treats this as an internal error and asks you to report it, this shouldn't be the case DONE
- refactor the formatting code some more
- pull some formatting code into separate classes
- test some of the utility formatting code
- a few more tests
- depends_on support
- improve the readme to explain:
  - a basic app with no options                              DONE
  - a basic app with options                                 DONE
    - supplying multiple of the same parameter using multi   DONE
  - a basic app with require arguments                       DONE
  - a basic app specifying version, description and summary  DONE
  - a basic app with options and validations
- up the version to 0.2.0
- tag and release

v1.0.0
- a few more integration tests (test that basic app automatically gets help and other automatic options)
- improve the readme to explain:
  - implementing and action for a basic app
  - a basic app with config file (don't worry about explaining all the helper stuff that gets created)
  - a basic app with conflicting options
  - a basic app with dependent options
  - a command app with options, validations, description, summary, require arguments and config file
  - a sub command app with options, validations, description, summary, require arguments and config file
- rework the examples again to show of some/most of the features (along the lines of the integration tests and readme)
- extract all the dsl command stuff into a helper module so that global and command can be handled by the same code
- up the version to 1.0.0
- tag and release
- get the blog updated with a new theme
- put a new subscriber count widget on blog
- blog Build Command-Line Apps Like a Pro Using Ruby and Escort

v1.0.1
- more specs (setup accessor etc)
- more integration specs (more specs for the different types of options)
- rework the integration specs and matchers so there are less moving parts (perhaps push some stuff down into a base class etc.) DONE
- lots more logging at different levels for debug purposes
- add validation messages to help text
- a way have helpers available when you don't want to have to create a command
- the config auto option should not be included in the config file, same with other auto options
- readme about how to actually pass the user config through to action and the fact that regardless if you have a config file or not, you can have a config var or not as part of the block variables
- rewrite the help formatter to be a bit easier to understand (more like man output for output) DONE
- add depends support to dsl
- ability to specify a different command based on options declaratively or a convention for how to do different things for the same action based on options (bunch of options that are flags, options that are a clump of values etc)

v1.0.2
- more specs
- scaffold for app with no sub commands
- scaffold for app with one level of commands
- scaffold for app with nested sub commands

v1.0.3
- an option for setup that indicates it is a project specific CLI app
- an options for setup that indicates it is an environment aware CLI app
- make the configuration environment aware
- make escort environment aware
- json configuration should support defaults config
- much better documentation and usage patterns
- pull the terminal formatting stuff into separate gem




BUCKET
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
