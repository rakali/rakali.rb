# encoding: UTF-8

module Rakali
  class Document

    attr_accessor :config, :source, :destination, :content, :schema, :errors, :options, :variables, :filters, :to_folder

    def initialize(document, config)
      begin
        @config = config

        @from_folder = @config.fetch('from').fetch('folder')
        @from_format = @config.fetch('from').fetch('format')
        @to_folder = @config.fetch('to').fetch('folder') || @from_folder
        @to_format = @config.fetch('to').fetch('format')

        # if document is a list of files, concatenate into one input
        # use to_folder name as filename
        if document.is_a?(Array)
          @source = document.map { |file| File.basename(file) }.join(" ")
          @destination = "#{File.basename(@from_folder)}.#{@to_format}"
          content = document.map { |file| IO.read(file) }.join("\n\n")
        else
          # otherwise use source name with new extension for destination filename
          @source = File.basename(document)
          @destination = @source.sub(/\.#{@from_format}$/, ".#{@to_format}")
          content = IO.read(document)
        end

        # add pandoc options from config
        options = @config.fetch('options') || {}
        @options = options.map { |k,v| "--#{k}=#{v}" }.join(" ")

        # add pandoc variables from config
        variables = @config.fetch('variables', nil) || {}
        @variables = variables.map { |k,v| "--variable #{k}='#{v}'" }.join(" ")

        # add pandoc filters from config
        @filters = filter

        # use citeproc-pandoc if citations flag is set
        bibliography = @config.fetch('citations') ? "-f citeproc-pandoc " : ""

        # convert source document into JSON version of native AST
        # read in document and parse to Pandoc via STDIN to allow filenames with spaces
        @content = convert(content, @from_folder, "#{@source} #{bibliography}-t json #{@options} #{@variables} #{@filters}")

        # read in JSON schema, use included schemata folder if no folder is given
        @schema = scheme

        # validate JSON against schema and report errors
        @errors = validate

        # convert to destination document from JSON version of native AST
        @output = convert(@content, @to_folder, "-f json #{bibliography}-o #{@destination} #{@options} #{@variables} #{@filters}")
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
      unless exit_status.success?
        Rakali.logger.error "Pandoc Args:", "#{args}."
        Rakali.logger.abort_with "Fatal:", "#{captured_stderr}."
      end

      # otherwise return stdout
      captured_stdout
    end

    def scheme
      schema = @config.fetch('schema')
      if schema.include?("/")
        IO.read(schema)
      else
        schemata_folder = File.expand_path("../../../schemata", __FILE__)
        IO.read("#{schemata_folder}/#{schema}")
      end
    end

    def filter
      filters = @config.fetch('filters', nil) || []
      filters.map do |f|
        if f.include?("/")
          "--filter=#{f}"
        else
          filters_folder = File.expand_path("../../../filters", __FILE__)
          "--filter=#{filters_folder}/#{f}"
        end
      end.join(" ")
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
