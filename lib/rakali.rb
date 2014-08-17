require "thor"
require 'safe_yaml/load'
require 'colorator'
require 'json-schema'
require 'json'
require 'open3'

require 'rakali/version'
require 'rakali/cli'
require 'rakali/converter'
require 'rakali/document'
require 'rakali/utils'
require 'rakali/logger'

SafeYAML::OPTIONS[:suppress_warnings] = false
SafeYAML::OPTIONS[:default_mode] = :safe

module Rakali
  def self.logger
    @logger ||= Logger.new
  end
end
