require 'json-schema'
require 'json'
require 'open3'

module Rakali
  class Document

    attr_accessor :input, :content, :output, :schema, :errors

    def initialize(input, options = {})
      begin
        schema = options.fetch(:schema, 'schemata/default.json')
        @schema = IO.read(schema)

        content = IO.read(input)
        content = convert(content, "-t json")
        @content = from_json(content)

        @errors = JSON::Validator.fully_validate(@schema, @content)

        basename = File.basename(input).split('.').first
        output = options.fetch(:output, "#{basename}.html")
        #@output = convert(content, "-f json -o #{output}")
      rescue => e
        @errors = [e.message]
      end
    end

    def convert(string, args)
      Open3::popen3("pandoc #{args}") do |stdin, stdout, stderr, wait_thr|
        stdin.puts string
        stdin.close

        raise StandardError, stderr.read if wait_thr.value.exitstatus > 0
        stdout.read
      end
    end

    def valid?
      errors == []
    end

    def from_json(string)
      JSON.parse(string)
    rescue JSON::ParserError, TypeError
      nil
    end

    def to_json
      content.to_json
    end
  end
end
