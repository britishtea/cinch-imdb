# encoding: utf-8

require "cinch"
require "cinch/plugins/imdb"

class Cinch::Plugins::Imdb
  prefix /^!/
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