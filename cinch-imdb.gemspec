Gem::Specification.new do |s|
  s.name        = 'cinch-imdb'
  s.version     = '0.1.1'
  s.summary     = "Search IMDb with a Cinch IRC bot"
  s.description = "Commandline like IMDB search with a Cinch IRC bot"
  s.authors     = ["Waxjar"]
  s.files       = ["lib/cinch/plugins/imdb.rb"]
  
  s.add_runtime_dependency 'cinch'
  s.add_runtime_dependency 'imdb_party', '~> 0.6.1'
end