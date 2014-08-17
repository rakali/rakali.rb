# This code was taken from Jekyll, available under MIT-LICENSE
# Copyright (c) 2008-2014 Tom Preston-Werner

module Rakali
  class Logger
    attr_accessor :log_level

    DEBUG  = 0
    INFO   = 1
    WARN   = 2
    ERROR  = 3

    # Public: Create a new logger instance
    #
    # level - (optional, integer) the log level
    #
    # Returns nothing
    def initialize(level = INFO)
      @log_level = level
    end

    # Public: Print a debug message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      $stdout.puts(message(topic, message)) if log_level <= DEBUG
    end

    # Public: Print a message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      $stdout.puts(message(topic, message)) if log_level <= INFO
    end

    # Public: Print a message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      $stderr.puts(message(topic, message).yellow) if log_level <= WARN
    end

    # Public: Print a error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      $stderr.puts(message(topic, message).red) if log_level <= ERROR
    end

    # Public: Print a error message to stderr and immediately abort the process
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail (can be omitted)
    #
    # Returns nothing
    def abort_with(topic, message = nil)
      error(topic, message)
      abort
    end

    # Public: Build a topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      formatted_topic(topic) + message.to_s
    end

    # Public: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def formatted_topic(topic)
      "#{topic} ".rjust(20)
    end
  end
end
