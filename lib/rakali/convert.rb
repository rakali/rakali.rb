module Rakali
  class Convert < Thor
    desc "convert", "convert STDIN or FILE"

    method_option :read, :aliases => "-r", :banner => "FILE", :desc => "Path to Pandoc JSON file"

    def convert
      if $stdin.tty?
        data = options[:read] && File.exists?(options[:read]) ? IO.read(options[:read]) : nil
      else
        data = $stdin.read
      end
      raise Thor::Error, "Error: no input via STDIN or FILE" if data.nil?

      say data
    end
  end
end
