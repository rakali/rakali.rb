# encoding: UTF-8

module Rakali
  class Configuration < Hash

    # Default options.
    DEFAULTS = {
      'from'          => { 'folder' => '.', 'format' => 'md' },
      'to'            => { 'folder' => '.', 'format' => 'html' },
      'schemata'      => 'rakali/schemata',
      'templates'     => 'rakali/templates',
      'csl'           => 'rakali/csl',
      'bibliography'  => 'rakali/bibliography',
      'filters'       => 'rakali/filters',
      'writers'       => 'rakali/writers'
    }

    def read_config_file(file)
      config = SafeYAML.load_file(file)
      raise ArgumentError.new("Configuration file: (INVALID) #{file}".yellow) unless config.is_a?(Hash)
      Rakali.logger.info "Configuration file:", file
      config
    rescue SystemCallError
      Rakali.logger.error "Fatal:", "The configuration file '#{file}' could not be found."
      raise LoadError, "The Configuration file '#{file}' could not be found."
    end

  end
end
