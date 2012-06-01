# Cinch-imdb

## Features

- Command line-like search
- The ability to search for 'facts' such as runtime, rating, trailer or a list of actors
- Custom responses using lambdas.

## Usage

Cinch-imdb's syntax is fairly simple:
	
	!imdb [--option] title of the movie

Example response:
	
	[17:28:47] <~shades> !imdb the dark knight
	[17:28:54] <testsie> The Dark Knight (2008) - 8.9/10 - 152 min - Batman, Gordon and Harvey Dent are forced to deal with the chaos unleashed by a terrorist mastermind known only as the Joker, as he drives each of them to their limits. (http://imdb.com/title/tt0468569/)

Both `!imdb Toy Story 3` and `!imdb --runtime Toy Story 3` are valid commands. The available options are: title, imdb_id, tagline, plot, runtime, rating, release_date, poster_url, certification, trailer, genres, writers, directors and actors. Options are, well, optional.

## Configuration

Here's an example configuration of a Cinch bot that uses the cinch-imdb plugin

```ruby
require 'cinch'
require 'cinch/plugins/imdb'

bot = Cinch::Bot.new do
   	configure do |c|
      c.server          = "irc.freenode.net"
      c.nick            = "IMDb"
      c.channels        = ['#film'] 
      c.plugins.plugins = [Cinch::Plugins::IMDb]
	end
end
```

The `examples` folder contains some 'advanced' configurations that help you customize the responses.

## To do

- Search YouTube directly for trailers, instead of returning a search link.

## Changelog

### 1.1.1

- Fixed a bug where using httparty 0.8.3 produced an error.
- Slightly improved the search results.


### 1.1.0

- Custom responses are now lambdas instead of monkey-patched methods.
- IRC command now accepts `!imdb --fact ...` in addition to `!imdb -fact ...`.
- License changed from [Creative Commons](https://creativecommons.org/licenses/by-nc-sa/3.0/nl/deed.en) to MIT License.

## License - MIT License

Copyright (C) 2012 Paul Brickfeld

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.