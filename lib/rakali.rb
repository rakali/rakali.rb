require "thor"
require 'safe_yaml/load'
require 'colorator'

require 'rakali/version'
require 'rakali/cli'
require 'rakali/document'
require 'rakali/configuration'
require 'rakali/logger'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Rakali
  def self.configuration(file)
    config = Configuration[Configuration::DEFAULTS]
    config = config.merge(Configuration.read_config_file(file))
  end

  def self.logger
    @logger ||= Logger.new
  end
end
