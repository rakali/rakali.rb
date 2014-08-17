# encoding: UTF-8

module Rakali
  class Converter

    # Default options.
    DEFAULTS = {
      'from'          => { 'format' => 'md' },
      'to'            => { 'folder' => nil, 'format' => 'html' },
      'schema'        => 'schemata/default.json',
      'strict'        => false,
      'templates'     => 'rakali/templates',
      'csl'           => 'rakali/csl',
      'bibliography'  => 'rakali/bibliography',
      'filters'       => 'rakali/filters',
      'writers'       => 'rakali/writers'
    }

    attr_accessor :config, :documents, :errors

    def initialize(file, options = {})
      begin
        config = read_config_file(file)

        # deep merge defaults to preserve nested keys
        @config = Utils.deep_merge_hashes(DEFAULTS, config)

        # print configuration
        Rakali.logger.info "Starting:", "Reading configuration... \n#{to_yaml}"

        from_folder = @config.fetch('from').fetch('folder')
        from_format = @config.fetch('from').fetch('format')
        documents = Dir.glob("#{from_folder}/*.#{from_format}")
        documents.each { |document| Rakali::Document.new(document, @config) }
      rescue KeyError => e
        Rakali.logger.abort_with "Fatal:", "Configuration #{e.message}."
      rescue => e
        Rakali.logger.abort_with "Fatal:", "#{e.message}."
      end
    end

    def read_config_file(file)
      # use an empty hash if the file is empty
      SafeYAML.load_file(file) || {}
    rescue SystemCallError
      Rakali.logger.abort_with "Fatal:", "Configuration file not found: \"#{file}\"."
    end

    def from_json(string)
      JSON.parse(string)
    rescue JSON::ParserError, TypeError
      nil
    end

    def to_json
      content.to_json
    end

    def to_yaml
      config.to_yaml
    end
  end
end
