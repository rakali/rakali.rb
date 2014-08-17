# encoding: UTF-8

module Rakali
  class Document

    attr_accessor :config, :source, :destination, :content, :schema, :errors, :to_folder

    def initialize(document, config)
      begin
        @config = config

        @from_folder = @config.fetch('from').fetch('folder')
        @from_format = @config.fetch('from').fetch('format')
        @to_folder = @config.fetch('to').fetch('folder') || @from_folder
        @to_format = @config.fetch('to').fetch('format')

        # for destination filename use source name with new extension
        @source = File.basename(document)
        @destination = @source.sub(/\.#{@from_format}$/, ".#{@to_format}")

        # convert source document into JSON version of native AST
        @content = convert(nil, @from_folder, "#{@source} -t json")

        # read in JSON schema
        @schema = IO.read(@config.fetch('schema'))

        # validate JSON against schema and report errors
        @errors = validate

        # convert to destination document from JSON version of native AST
        @output = convert(@content, @to_folder, "-f json -o #{@destination}")
        Rakali.logger.abort_with "Fatal:", "Writing file #{@destination} failed" unless created?

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

    def convert(string = nil, dir, args)
      captured_stdout = ''
      captured_stderr = ''
      exit_status = Open3::popen3("pandoc #{args}", chdir: dir) do |stdin, stdout, stderr, wait_thr|
        stdin.puts string unless string.nil?
        stdin.close

        captured_stdout = stdout.read
        captured_stderr = stderr.read
        wait_thr.value
      end

      # abort with log message if non-zero exit_status
      Rakali.logger.abort_with "Fatal:", "#{captured_stderr}." unless exit_status.success?

      # otherwise return stdout
      captured_stdout
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

    def created?
      # file exists
      return false unless File.exist?("#{@to_folder}/#{@destination}")

      # file was created in the last 5 seconds
      Time.now - File.mtime("#{@to_folder}/#{@destination}") < 5
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
