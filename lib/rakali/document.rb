require 'json-schema'
require 'json'

module Rakali
  class Document

    attr_accessor :content, :schema, :errors, :to_json

    def initialize(options = {})
      if $stdin.tty?
        input = options.fetch(:read, '')
        input = File.exists?(input) ? IO.read(input) : "[]"
      else
        input = $stdin.read
      end

      schema = options.fetch(:schema, 'schemata/default.json')
      schema = File.exists?(schema) ? IO.read(schema) : IO.read('schemata/default.json')

      @content = JSON.parse(input)
      @schema = JSON.parse(schema)

      @errors = JSON::Validator.fully_validate(schema, to_json)
    end

    def valid?
      errors.size == 0
    end

    def to_json
      content.to_json
    end
  end
end
