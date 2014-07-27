# Pandoc filter to convert all regular text to uppercase.
# Code, link URLs, etc. are not affected.
# Adapted from Python example at https://github.com/jgm/pandocfilters/blob/master/examples/caps.py

module Rakali::Filters::Caps

  def caps(key, value, format, meta)
    if key == 'Str'
      value.upcase
    end
  end
end
