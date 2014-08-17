# encoding: UTF-8

module Rakali
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "read FILE", "read configuration FILE in yaml format"

    def convert(file)
      converter = Rakali::Converter.new(file)
    end

    default_task :convert
  end
end
