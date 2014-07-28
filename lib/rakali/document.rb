require 'json-schema'
require 'json'
require 'open3'

module Rakali
  class Document

    attr_accessor :content, :schema, :errors, :to_json

    def initialize(options = {})
      if $stdin.tty?
        input = options.fetch(:file, '')
        if File.exists?(input)
          input = IO.read(input)
        else
          @errors = ["No such file or directory"]
          input = nil
        end
      else
        input = $stdin.read
      end

      output = ''
      stderr = nil
      Open3::popen3("pandoc -t json") do |stdin, stdout, stderr|
        stdin.puts input
        stdin.close
        output = stdout.read
      end

      schema = options.fetch(:schema, 'schemata/default.json')
      schema = File.exists?(schema) ? IO.read(schema) : IO.read('schemata/default.json')

      @content = from_json(output)
      @schema = from_json(schema)

      if stderr
        @errors = [stderr]
      elsif content.nil? || schema.nil?
        @errors = ["No input found"]
      else
        @errors = JSON::Validator.fully_validate(schema, to_json)
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
