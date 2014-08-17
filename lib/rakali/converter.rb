# encoding: UTF-8

module Rakali
  class Converter

    # Default options.
    DEFAULTS = {
      'from'          => { 'format' => 'md' },
      'to'            => { 'format' => 'html' },
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
        @config = deep_merge_hashes(DEFAULTS, config)

        from_folder = @config.fetch('from').fetch('folder')
        from_format = @config.fetch('from').fetch('format')
        documents = Dir.glob("#{from_folder}/*.#{from_format}")
        @documents = documents.map { |document| Rakali::Document.new(document, @config) }
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

    # This code was taken from Jekyll, available under MIT-LICENSE
    # Copyright (c) 2008-2014 Tom Preston-Werner
    # Merges a master hash with another hash, recursively.
    #
    # master_hash - the "parent" hash whose values will be overridden
    # other_hash  - the other hash whose values will be persisted after the merge
    #
    # This code was lovingly stolen from some random gem:
    # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
    def deep_merge_hashes(master_hash, other_hash)
      target = master_hash.dup

      other_hash.keys.each do |key|
        if other_hash[key].is_a? Hash and target[key].is_a? Hash
          target[key] = deep_merge_hashes(target[key], other_hash[key])
          next
        end

        target[key] = other_hash[key]
      end

      target
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
