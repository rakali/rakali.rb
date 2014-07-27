module Rakali
  class Utils < Thor
    def read_stdin(options)
      if $stdin.tty?
        options[:read] && File.exists?(options[:read]) ? IO.read(options[:read]) : nil
      else
        $stdin.read
      end
    end
  end
end
