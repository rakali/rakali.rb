# encoding: UTF-8

module Rakali
  class Document

    attr_accessor :config, :source, :destination, :content, :schema, :errors

    def initialize(document, config)
      begin
        @config = config

        from_folder = @config.fetch('from').fetch('folder')
        from_format = @config.fetch('from').fetch('format')
        to_folder = @config.fetch('to').fetch('folder') || from_folder
        to_format = @config.fetch('to').fetch('format')
        #config_path = File.expand_path("../config.yml", __FILE__)

        # for destination filename use source name with new extension
        @source = File.basename(document)
        @destination = @source.sub(/\.#{from_format}$/, ".#{to_format}")

        # convert source document into JSON version of native AST
        @content = convert(nil, "#{from_folder}/#{@source} -t json")

        # read in JSON schema
        @schema = IO.read(@config.fetch('schema'))

        # validate JSON against schema and report errors
        @errors = validate

        # convert to destination document from JSON version of native AST
        @output = convert(@content, "-f json -o #{to_folder}/#{@destination}")

        if @errors.empty?
          Rakali.logger.info "Success:", "Converted file #{@source} to file #{@destination}."
        else
          Rakali.logger.warn "With Errors:", "Converted file #{@source} to file #{@destination}."
        end
      rescue KeyError => e
        Rakali.logger.abort_with "Fatal:", "Configuration #{e.message}."
      rescue => e
        Rakali.logger.abort_with "Fatal:", "#{e.message}."
      end
    end

    def convert(string = nil, args)
      Open3::popen3("pandoc #{args}") do |stdin, stdout, stderr, wait_thr|
        unless string.nil?
          stdin.puts string
          stdin.close
        end

        # abort with log message if exit_status of command not 0
        Rakali.logger.abort_with "Fatal:", "#{stderr.read}." if wait_thr.value.exitstatus > 0

        stdout.read
      end
    end

    def validate
      errors = JSON::Validator.fully_validate(@schema, @content)
      return [] if errors.empty?

      if @config.fetch('strict', false)
        errors.each { |error| Rakali.logger.error "Validation Error:", "#{error} for file #{source}" }
        Rakali.logger.abort_with "Fatal:", "Conversion of file #{source} failed."
      else
        errors.each { |error| Rakali.logger.warn "Validation Error:", "#{error} for file #{source}" }
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
