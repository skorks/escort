module Escort
  module ActionCommand
    class Base
      attr_reader :options, :arguments, :config

      def initialize(options, arguments, config={})
        @options = options
        @arguments = arguments
        @config = config
        @command_context = nil
        @command_options = nil
        @parent_options = nil
        @grandparent_options = nil
        @global_options = nil
      end

      protected

      def command_context
        return @command_context if @command_context
        @command_context = []
        current_command_hash = options[:global][:commands]
        until current_command_hash.keys.empty?
          key = current_command_hash.keys.first
          @command_context << key
          current_command_hash = current_command_hash[key][:commands]
        end
        @command_context
      end

      def command_options
        @command_options ||= context_hash(command_context)[:options] || {}
      end

      def global_options
        @global_options ||= options[:global][:options] || {}
      end

      def parent_options
        @parent_options ||= ensure_parent{ |parent_context| context_hash(parent_context)[:options] || {} }
      end

      def grandparent_options
        @grandparent_options ||= ensure_grandparent{ |grandparent_context| context_hash(grandparent_context)[:options] || {} }
      end

      #generation_number 1 is parent, 2 is grandparent and so on
      #default is 3 for great grandparent
      def ancestor_options(generation_number = 3)
        ensure_ancestor(generation_number){ |ancestor_context| context_hash(ancestor_context)[:options] || {} }
      end

      private

      def context_hash(context)
        context_hash = options[:global]
        context.each do |command_name|
          context_hash = context_hash[:commands][command_name]
        end
        context_hash
      end

      def ensure_parent(&block)
        ensure_ancestor(1, &block)
        #return {} unless command_context.size > 1
        #ancestor_context = command_context.dup.slice(0, command_context.size - 2)
        #block.call(ancestor_context)
      end

      def ensure_grandparent(&block)
        ensure_ancestor(2, &block)
        #return {} unless command_context.size > 2
        #ancestor_context = command_context.dup.slice(0, command_context.size - 2)
        #block.call(ancestor_context)
      end

      def ensure_ancestor(generation_number, &block)
        return {} if generation_number < 1
        return {} unless command_context.size > generation_number
        ancestor_context = command_context.dup.slice(0, command_context.size - generation_number)
        block.call(ancestor_context)
      end
    end
  end
end
