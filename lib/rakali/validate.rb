require 'json-schema'
require 'json'
require 'rakali/utils'

module Rakali
  class Validate < Thor
    desc "validate", "validate STDIN or FILE against SCHEMA"

    method_option :read, :aliases => "-r", :banner => "FILE", :desc => "Path to Pandoc JSON file"
    method_option :schema, :aliases => "-s", :desc => "Path to JSON validator SCHEMA", :default => "schemata/default"

    def validate
      data = read_stdin(options)
      raise Thor::Error, "Error: no input via STDIN or FILE" if data.nil?

      schema = IO.read("#{options[:schema]}.json")
      schema = JSON.parse(schema)
      errors = JSON::Validator.fully_validate(schema, data)

      raise Thor::Error, set_color("Error: input did not validate with schema #{schema["title"]}\n" + errors.join("\n"), :red) if errors.size > 0

      say data
    end
  end
end
