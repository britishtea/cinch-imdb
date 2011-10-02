# encoding: utf-8

require 'cinch'
require_relative '../cinch-imdb/lib/cinch/plugins/imdb.rb'

class Cinch::Plugins::Imdb
  def standard_response(movie)
    stars = String.new
    movie.rating.to_i.times { stars << "★" }
    stars << "☆" until stars.length == 10
    
    "#{movie.title} - #{stars}"
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "testsie"
    c.port = 6667
    c.server = "irc.what-network.net"
    c.channels = ["#film"]
    
    c.plugins.plugins = [Cinch::Plugins::Imdb]
  end
end

bot.start