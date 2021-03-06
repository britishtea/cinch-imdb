# encoding: utf-8

require "cinch"
require "cinch/plugins/imdb"

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "testsie"
    c.port = 6667
    c.server = "irc.what-network.net"
    c.channels = ["#film"]
    
    c.plugins.plugins = [Cinch::Plugins::IMDb]
    
    c.plugins.options[Cinch::Plugins::IMDb] = {
      :standard => lambda { |movie|
        stars = String.new
        movie.rating.to_i.times { stars << "★" }
        stars << "☆" until stars.length == 10

        "#{movie.title} - #{stars}"
      },
      :fact => lambda{ |movie, fact, result| 
        "The #{fact} for #{movie.title} is #{result}"
      },
      :not_found => lambda { |query| 
        "Sorry bud, can't find #{query} anywhere."
      }
    }
  end
end

bot.start
