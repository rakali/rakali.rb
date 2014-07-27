module Rakali
  class Filter < Thor
    desc "filter", "filter STDIN or FILE with FILTER"

    method_option :read, :aliases => "-r", :banner => "FILE", :desc => "Path to Pandoc JSON file"
    method_option :filter, :aliases => "-f", :desc => "Path to FILTER", :default => "filters/default"

    def filter
      if $stdin.tty?
        data = options[:read] && File.exists?(options[:read]) ? IO.read(options[:read]) : nil
      else
        data = $stdin.read
      end
      raise Thor::Error, "Error: no input via STDIN or FILE" if data.nil?

      filter = IO.read("#{options[:filter]}.json")
      # errors = JSON::Validator.fully_validate(schema, data)

      # raise Thor::Error, set_color("Error: input did not validate with schema #{options[:schema]}\n" + errors.join("\n"), :red) if errors.size > 0

      say data
    end
  end
end
