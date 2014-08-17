# encoding: UTF-8

module Rakali
  class Document

    attr_accessor :config, :content, :schema, :errors

    def initialize(document, config)
      begin
        @config = config

        # convert input document into JSON version of native AST
        @content = convert(IO.read(document), "-t json")

        # read in JSON schema
        @schema = IO.read(@config['schema'])

        # validate JSON against schema
        @errors = JSON::Validator.fully_validate(@schema, @content)

        # basename = File.basename(document).split('.').first
        #@output = convert(content, "-f json -o #{output}")
      rescue => e
        @errors = [e.message]
      end
    end

    def convert(string, args)
      Open3::popen3("pandoc #{args}") do |stdin, stdout, stderr, wait_thr|
        stdin.puts string
        stdin.close

        # raise an error if exit_status of command not 0
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
