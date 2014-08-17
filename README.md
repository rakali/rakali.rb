rakali.rb
=========

[![Build Status](https://travis-ci.org/rakali/rakali.rb.svg)](https://travis-ci.org/rakali/rakali.rb)
[![Gem Version](https://badge.fury.io/rb/rakali.svg)](http://badge.fury.io/rb/rakali)
[![Code Climate](https://codeclimate.com/github/rakali/rakali.rb.png)](https://codeclimate.com/github/rakali/rakali.rb)

Rakali is a wrapper for the [Pandoc](http://johnmacfarlane.net/pandoc/) document converter with the following features:

* bulk conversion of all files in a folder with a specific extension, e.g. `.md`.
* input via a configuration file in yaml format instead of via the command line
* validation of documents via [JSON Schema](http://json-schema.org/), using the [json-schema](https://github.com/hoxworth/json-schema) Ruby gem.
* Logging via `stdout` and `stderr`.

## Installation

```
gem install rakali
```

## Use

Provide a configuration file in yaml format as input:

```
rakali convert .rakali.yml
```

The default configuration looks like this:

```
from:
  folder:
  format: md
to:
  format: html
schema: default.json
citations: false
strict: false
merge: false
```

The only required key for the input yaml file is `from` `folder` (missing in the default file), and you can override any key in the default file.

* **schema**: JSON schema used for validation. Use `your_folder/schema.json` for a custom schema, or use one of the built-in schemata (see [pandoc-schemata](https://github.com/rakali/pandoc-schemata) for a list.)
* **citations**: include `-f citeproc-pandoc` for citation formatting
* **strict**: abort conversion on validation errors
* **merge**: merge all input files into a single file

Validation against **JSON Schema** also works directly with Pandoc, generate a JSON representation of the internal Pandoc document format (abstract syntax tree or AST) with `pandoc -o file.json`, and use a JSON Schema file for validation. If possible, please contribute your schema files to the [pandoc-schemata](https://github.com/rakali/pandoc-schemata).

To integrate rakali into a continuous integration environment such as [Travis CI](https://travis-ci.org), add a configuration file (e.g. `.rakali.yml`) into the root folder of your repo, install Pandoc and the rakali gem and run `rakali convert .rakali.yml`. Look at `.travis.yml`, `.rakali.yml` and the `examples` folder in this repo for a working example.

## Feedback

This is an early release version. Please provide feedback via the [issue tracker](https://github.com/rakali/rakali.rb/issues).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
[MIT License](LICENSE).
