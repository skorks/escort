require 'escort/version'
require 'escort/trollop'
require 'escort/utils'
require 'escort/arguments'
require 'escort/logger'

require 'escort/error/error'

require 'escort/formatter/terminal'
require 'escort/formatter/string_splitter'
require 'escort/formatter/terminal_formatter'
require 'escort/formatter/borderless_table'
require 'escort/formatter/common'
require 'escort/formatter/default_help_formatter'

require 'escort/setup/dsl/options'
require 'escort/setup/dsl/action'
require 'escort/setup/dsl/validations'
require 'escort/setup/dsl/command'
require 'escort/setup/dsl/config_file'
require 'escort/setup/dsl/global'

require 'escort/setup/configuration/locator/base'
require 'escort/setup/configuration/locator/descending_to_home'
require 'escort/setup/configuration/merge_tool'
require 'escort/setup/configuration/instance'
require 'escort/setup/configuration/reader'
require 'escort/setup/configuration/writer'
require 'escort/setup/configuration/generator'
require 'escort/setup/configuration/loader'

require 'escort/setup_accessor'

require 'escort/option_dependency_validator'
require 'escort/validator'
require 'escort/auto_options'
require 'escort/global_pre_parser'
require 'escort/option_parser'

require 'escort/action_command/base'
require 'escort/action_command/escort_utility_command'

require 'escort/app'

at_exit do
  Escort::Logger.close
end

def error_logger
  Escort::Logger.error
end

def output_logger
  Escort::Logger.output
end


