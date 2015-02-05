autoload :Nesty,                            "nesty"

module Escort
  autoload :VERSION,                        "escort/version"
  autoload :Trollop,                        "escort/trollop"
  autoload :Utils,                          "escort/utils"
  autoload :Arguments,                      "escort/arguments"
  autoload :Logger,                         "escort/logger"
  autoload :SetupAccessor,                  "escort/setup_accessor"
  autoload :OptionDependencyValidator,      "escort/option_dependency_validator"
  autoload :Validator,                      "escort/validator"
  autoload :AutoOptions,                    "escort/auto_options"
  autoload :GlobalPreParser,                "escort/global_pre_parser"
  autoload :OptionParser,                   "escort/option_parser"
  autoload :App,                            "escort/app"

  autoload :Error,                          "escort/error/error"
  autoload :BaseError,                      "escort/error/error"
  autoload :UserError,                      "escort/error/error"
  autoload :InternalError,                  "escort/error/error"
  autoload :ClientError,                    "escort/error/error"
  autoload :TransientError,                 "escort/error/error"

  module Formatter
    autoload :Option,                       "escort/formatter/option"
    autoload :Options,                      "escort/formatter/options"
    autoload :Command,                      "escort/formatter/command"
    autoload :Commands,                     "escort/formatter/commands"
    autoload :GlobalCommand,                "escort/formatter/global_command"
    autoload :ShellCommandExecutor,         "escort/formatter/shell_command_executor"
    autoload :Terminal,                     "escort/formatter/terminal"
    autoload :StringSplitter,               "escort/formatter/string_splitter"
    autoload :CursorPosition,               "escort/formatter/cursor_position"
    autoload :StreamOutputFormatter,        "escort/formatter/stream_output_formatter"
    autoload :StringGrid,                   "escort/formatter/string_grid"
    autoload :DefaultHelpFormatter,         "escort/formatter/default_help_formatter"
  end

  module Setup
    module Dsl
      autoload :Options,                    "escort/setup/dsl/options"
      autoload :Action,                     "escort/setup/dsl/action"
      autoload :Command,                    "escort/setup/dsl/command"
      autoload :ConfigFile,                 "escort/setup/dsl/config_file"
      autoload :Global,                     "escort/setup/dsl/global"
    end

    module Configuration
      module Locator
        autoload :Base,                     "escort/setup/configuration/locator/base"
        autoload :DescendingToHome,         "escort/setup/configuration/locator/descending_to_home"
        autoload :ExecutingScriptDirectory, "escort/setup/configuration/locator/executing_script_directory"
        autoload :SpecifiedDirectory,       "escort/setup/configuration/locator/specified_directory"
        autoload :Chaining,                 "escort/setup/configuration/locator/chaining"
      end

      autoload :MergeTool,                  "escort/setup/configuration/merge_tool"
      autoload :Instance,                   "escort/setup/configuration/instance"
      autoload :Reader,                     "escort/setup/configuration/reader"
      autoload :Writer,                     "escort/setup/configuration/writer"
      autoload :Generator,                  "escort/setup/configuration/generator"
      autoload :Loader,                     "escort/setup/configuration/loader"
    end
  end

  module ActionCommand
    autoload :Base,                         "escort/action_command/base"
    autoload :EscortUtilityCommand,         "escort/action_command/escort_utility_command"
  end
end

def error_logger
  Escort::Logger.error
end

def output_logger
  Escort::Logger.output
end
