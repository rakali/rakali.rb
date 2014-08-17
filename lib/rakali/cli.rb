# encoding: UTF-8

module Rakali
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "read FILE", "read configuration FILE in yaml format"

    def convert(file)
      converter = Rakali::Converter.new(file)

      # don't proceed unless input validates against schema
      unless converter.valid?
        message = "Error: input did not validate with schema #{converter.schema["title"]}\n" + converter.errors.join("\n")
        raise Thor::Error, message
      end
    end

    default_task :convert
  end
end
