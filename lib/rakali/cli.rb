#!/usr/bin/env ruby
require "thor"
require 'open3'

class Cli < Thor
  desc "pandoc", "an example task"

  method_option :from, :aliases => "-f", :banner => "FORMAT", :desc => <<-EOF
Specify input format. FORMAT can be
                                     * native (native Haskell),
                                     * json (JSON version of native AST),
                                     * markdown (pandoc’s extended markdown),
                                     * markdown_strict (original unextended
                                       markdown),
                                     * markdown_phpextra (PHP Markdown Extra
                                       extended markdown),
                                     * markdown_github (github extended
                                       markdown),
                                     * textile (Textile),
                                     * rst (reStructuredText),
                                     * html (HTML),
                                     * docbook (DocBook),
                                     * opml (OPML),
                                     * org (Emacs Org-mode),
                                     * mediawiki (MediaWiki markup),
                                     * haddock (Haddock markup),
                                     * latex (LaTeX).

                                     If +lhs is appended to markdown, rst,
                                     latex, or html, the input will be treated
                                     as literate Haskell source: see Literate
                                     Haskell support, below. Markdown syntax
                                     extensions can be individually enabled or
                                     disabled by appending +EXTENSION or
                                     -EXTENSION to the format name. So, for
                                     example,
                                     markdown_strict+footnotes+definition_lists
                                     is strict markdown with footnotes and
                                     definition lists enabled, and
                                     markdown-pipe_tables+hard_line_breaks
                                     is pandoc’s markdown without pipe tables
                                     and with hard line breaks. See
                                     Pandoc’s markdown, below, for a list of
                                     extensions and their names.
  EOF

  method_option :output, :aliases => "-o", :banner => "FILE", :desc => <<-EOF
Write output to FILE instead of stdout.
                                     If FILE is -, output will go to stdout.
                                     (Exception: if the output format is odt,
                                     docx, epub, or epub3, output to stdout is
                                     disabled.)
  EOF

  method_option "data-dir".to_sym, :banner => "DIRECTORY", :desc => <<-EOF
Specify the user data directory to
                                     search for pandoc data files. If this
                                     option is not specified, the default user
                                     data directory will be used. This is

                                     $HOME/.pandoc
                                     in unix,

                                     C:/\Documents And Settings/\USERNAME/\
                                             Application Data/\pandoc
                                     in Windows XP, and

                                     C:/\Users/\USERNAME/\AppData/\Roaming/\pandoc
                                     in Windows 7. (You can find the default
                                     user data directory on your system by
                                     looking at the output of pandoc --version.)
                                     A reference.odt, reference.docx,
                                     default.csl, epub.css, templates, slidy,
                                     slideous, or s5 directory placed in this
                                     directory will override pandoc’s normal
                                     defaults.
  EOF

  method_option :version, :aliases => "-v", :type => :boolean, :desc => "Print version."

  method_option :help, :aliases => "-h", :type => :boolean, :desc => "Show usage message."

  method_option "parse-raw".to_sym, :aliases => "-R", :type => :boolean

  method_option :smart, :aliases => "-S", :type => :boolean

  method_option "old-dashes".to_sym, :type => :boolean

  method_option "base-header-level".to_sym, :banner => "NUMBER"

  # Runs the command and returns the output.
  def pandoc
    output = ''
    Open3::popen3("pandoc -v") do |stdin, stdout, stderr|
      stdin.puts ""
      stdin.close
      output = stdout.read
    end
    puts output
  end
end

Cli.start
