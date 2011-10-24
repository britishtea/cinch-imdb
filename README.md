Features
========

- Commandline-like search
- The ability to search for 'facts' such as runtime, rating, trailer or a list of actors
- Customizable responses

Usage
=====

Cinch-imdb's syntax is fairly simple:
	
	:imdb [-option] Movie

Example response:
	
	[20:31:22] <~shades> :imdb toy story 3
	[20:31:23] <PervServ> Toy Story 3 (2010) - 8.6/10  - 103 min - http://imdb.com/title/tt0435761/
	[20:31:23] <PervServ> Plot: The toys are mistakenly delivered to a day-care center instead of the attic right before Andy leaves for college, and it's up to Woody to convince the other toys that they weren't abandoned and to return home.

Both `:imdb Toy Story 3` and `:imdb -runtime Toy Story 3` are valid commands. The available options are: title, imdb_id, tagline, plot, runtime, rating, release_date, poster_url, certification, trailer, genres, writers, directors and actors. Options are, well, optional.

Configuration
=============

Here's an example configuration of a Cinch bot that uses the cinch-imdb plugin

	require 'cinch'
	require 'cinch/plugins/imdb'
	
	bot = Cinch::Bot.new do
    	configure do |c|
	      c.server          = "irc.freenode.net"
	      c.nick            = "IMDb"
	      c.channels        = ['#film'] 
	      c.plugins.plugins = [Cinch::Plugins::Imdb]
		end
	end

The 'examples' folders contains some 'advanced' configurations that help you customize the responses for the cinch-imdb plugin.

To do
=====

- Search YouTube directly for trailers, instead of returning a search link

License
=======

https://creativecommons.org/licenses/by-nc-sa/3.0/nl/deed.en