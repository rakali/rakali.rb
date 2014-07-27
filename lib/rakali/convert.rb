require 'rakali/utils'

module Rakali
  class Convert < Thor
    desc "convert", "convert STDIN or FILE"

    method_option :read, :aliases => "-r", :banner => "FILE", :desc => "Path to Pandoc JSON file"

    def convert
      data = read_stdin(options)
      raise Thor::Error, "Error: no input via STDIN or FILE" if data.nil?

      say data
    end
  end
end
