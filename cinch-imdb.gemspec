$:.push File.expand_path('../lib', __FILE__)
require 'cinch/plugins/imdb/version'

Gem::Specification.new do |s|
  s.name        = 'cinch-imdb'
  s.version     = Cinch::Plugins::IMDb::VERSION
  s.summary     = "Search IMDb with a Cinch IRC bot"
  s.description = "Commandline like IMDb search with a Cinch IRC bot."
  s.authors     = ["Waxjar"]
  s.license     = 'MIT'
  s.files       = ["lib/cinch/plugins/imdb.rb"]
  
  s.add_dependency 'cinch', '~> 2.0.0.pre'
  s.add_dependency 'imdb_party', '~> 0.6.1'
end