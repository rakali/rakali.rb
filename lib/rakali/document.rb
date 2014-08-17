# encoding: UTF-8

module Rakali
  class Document

    attr_accessor :config, :basename, :content, :schema, :errors

    def initialize(document, config)
      begin
        @config = config
        @basename = File.basename(document)

        # convert input document into JSON version of native AST
        @content = convert(IO.read(document), "-t json")

        # read in JSON schema
        @schema = IO.read(@config.fetch('schema'))

        # validate JSON against schema and report errors
        @errors = validate

        #@output = convert(content, "-f json -o #{output}")
      rescue => e
        Rakali.logger.abort_with "Fatal:", "#{e.message}."
      end
    end

    def convert(string, args)
      Open3::popen3("pandoc #{args}") do |stdin, stdout, stderr, wait_thr|
        stdin.puts string
        stdin.close

        # abort with log message if exit_status of command not 0
        Rakali.logger.abort_with "Fatal:", "#{stderr.read}." if wait_thr.value.exitstatus > 0

        stdout.read
      end
    end

    def validate
      errors = JSON::Validator.fully_validate(@schema, @content)
      return [] if errors.empty?

      if @config.fetch('strict', false)
        errors.each { |error| Rakali.logger.error "Validation Error:", "#{error} for file #{basename}" }
        Rakali.logger.abort_with "Fatal:", "Validation for file #{basename} failed."
      else
        errors.each { |error| Rakali.logger.warn "Validation Error:", "#{error} for file #{basename}" }
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
