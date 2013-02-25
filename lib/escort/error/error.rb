module Escort
  INTERNAL_ERROR_EXIT_CODE = 1
  CLIENT_ERROR_EXIT_CODE = 2
  USER_ERROR_EXIT_CODE = 3

  #module to tag all exceptions coming out of Escort with
  module Error
    class << self
      def fatal_client_error(message, error = nil)
        $stderr.puts message
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end
    end
  end

  #all our exceptions will supported nesting other exceptions
  #also all our exception will be a kind_of? Escort::Error
  class BaseError < StandardError
    include Error
    attr_reader :original

    def initialize(msg, original=$!)
      super(msg)
      @original = original
    end

    def set_backtrace(bt)
      if original
        original.backtrace.reverse.each do |line|
          bt.last == line ? bt.pop : break
        end
        original_first = original.backtrace.shift
        bt.concat ["#{original_first}: #{original.message}"]
        bt.concat original.backtrace
      end
      super(bt)
    end
  end

  #user did something invalid
  class UserError < BaseError
  end

  #for errors with escort itself
  class InternalError < BaseError
  end

  #for errors with how escort is being used
  class ClientError < BaseError
  end

  #a dependency is temporarily unavailable
  class TransientError < BaseError
  end
end
