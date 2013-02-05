#require 'fileutils'
require 'pathname'
require 'json'

module Escort
  module Setup
    class Configuration
      class << self
        def find_or_create_and_load(setup)
          file_name = setup.config_file
          config_path = nil
          config_path = find(file_name) if file_name
          config_path ? load_config(config_path) : create_default(setup, file_name)
        end

        def find_and_load(setup)
          file_name = setup.config_file
          config_path = nil
          config_path = find(file_name) if file_name
          config_path ? load_config(config_path) : {}
        end

        private

        def create_default(setup, file_name)
          default_data = Escort::Setup::ConfigurationGenerator.new(setup).generate
          config_path = write(default_path(file_name), default_data)
          load_config(config_path)
        rescue => e
          STDERR.puts "Unable to create default config file at #{config_path}. Continuing without config file..."
          {}
        end

        def load_config(file_path)
          config_path = file_path
          json = File.read(config_path)
          config_hash = JSON.parse(json)
          Escort::Utils.symbolize_keys(config_hash)
        rescue => e
          #p e
          #puts e.backtrace
          STDERR.puts "Found config at #{config_path}, but failed to load it, perhaps your JSON syntax is invalid. Continuing without config file..."
          {}
        end

        def find(file_name)
          configs = []
          Pathname.new(Dir.pwd).descend do |path|
            file_path = File.join(path, file_name)
            if File.exists?(file_path)
              configs << file_path
            end
          end
          configs.empty? ? nil : configs.last
        end

        def write(path, hash)
          path = File.expand_path(path)
          File.open(path,"w") do |f|
            f.puts JSON.pretty_generate(hash)
          end
          path
        end

        def default_path(file_name)
          file_path = File.join(File.expand_path(ENV["HOME"]), file_name)
        end
      end
      #attr_reader :config_hash

      #def initialize(config_hash)
        #@config_hash = config_hash
      #end

      #def global_options
        #config_hash[:global_options] || {}
      #end

      #def command_options
        #config_hash[:command_options] || {}
      #end

      #def user_data
        #config_hash[:user_data] || {}
      #end
    end
  end
end

      #def write(path = nil, hash = nil)
        #path ||= default_path
        #path = File.expand_path(path)
        #hash ||= default_config
        #File.open(path,"w") do |f|
          #f.puts JSON.pretty_generate(hash)
        #end
        #path
      #end

      #def write_default
        #write(default_path, default_config)
      #end

      #def default_path
        #file_path = File.join(File.expand_path(ENV["HOME"]), file_name)
      #end

      #def file_name
        #".mac_curl.conf"
      #end

      #def default_config
        #{
          #"log_level" => "ERROR",
          #"request_method" => "GET",
          #"headers" => {
            #"Content-Type" => "application/json",
            #"Accept" => "application/json, application/vnd.playup.*, */*"
          #},
          #"api_key" => "com.playup.ios.live",
          #"api_secret" => "QwFHK6n3WAqhDPiz"
        #}
      #end

      #def load_config(file_path = nil)
        #config_path = file_path || find
        #json = File.read(config_path)
        #config_hash = JSON.parse(json)
        #self.new(config_hash, file_path)
      #end

      #def find_and_load
        #config_path = find
        #load_config(config_path)
      #end
    #end

    #attr_reader :file_path, :config_hash

    #def initialize(config_hash, file_path)
      #@config_hash = config_hash
      #@file_path = file_path
    #end

    #def [](key)
      #@config_hash[key]
    #end

    #def write
      #MacCurl::Config.write(file_path, config_hash)
    #end
  #end
#end
