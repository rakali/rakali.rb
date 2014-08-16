require 'open3'

module Rakali
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "read FILE", "read configuration FILE in yaml format"

    def convert(file)
      document = Rakali::Document.new(file)

      # don't proceed unless input validates against schema
      unless document.valid?
        message = "Error: input did not validate with schema #{document.schema["title"]}\n" + document.errors.join("\n")
        raise Thor::Error, set_color(message, :red)
      end
    end

    default_task :pandoc
  end
end
