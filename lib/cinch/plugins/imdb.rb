require 'filmbuff'
require 'shortly'
require 'youtube_it'

require 'uri'

module Cinch
  module Plugins
    class IMDb
      include Cinch::Plugin
      
      set :plugin_name, 'imdb'
      set :help, "Usage: :imdb [--option] The Dark Knight\nOptions are: title, imdb_id, tagline, plot, runtime, rating, release_date, poster_url, certification, trailer, genres, writers, directors and actors."
      
      match /trailer (.+)/i,                             :method => :trailer 
      match /imdb -{1,2}trailer (.+)/i, :group => :imdb, :method => :trailer
      match /imdb -{0,2}more( .+)?/i,   :group => :imdb, :method => :more
      match /imdb -{1,2}(\S+) (.+)/i,   :group => :imdb, :method => :fact
      match /imdb (.+)$/i,              :group => :imdb, :method => :imdb
      
      # Internal: The facts that can be looked up.
      FACTS = ['title', 'imdb_id', 'tagline', 'plot', 'runtime', 'rating',
                'release_date', 'poster_url', 'certification', 'genres']    

      # Initializes the plugin.
      def initialize(*args)
        super
        
        @imdb    = FilmBuff::IMDb.new
        @youtube = YouTubeIt::Client.new
        @isgd    = Shortly::Clients::Isgd
        
        # The standard response when a movie is requested.
        @standard = self.config[:standard] || lambda do |movie|
          msg  = movie.title
          msg << " (#{movie.release_date.year})" unless movie.release_date.nil?
          msg << " - #{movie.rating}/10" unless movie.rating.nil?
          msg << " - #{movie.runtime}" unless movie.runtime.nil?
          msg << " - #{movie.plot}" unless movie.plot.nil?
          msg << " (http://imdb.com/title/#{movie.imdb_id}/)"

          msg
        end
        
        # The response when a specific fact is requested.
        @fact = self.config[:fact] || lambda do |movie, fact, result|
           "#{movie.title.capitalize} #{fact}: #{result}"
        end
        
        # The response when a movie couldn't be found.
        @not_found = self.config[:not_found] || lambda do |query|
          "Sorry, I can't find \"#{query}\" :("
        end
      end
      
      # Public: Look up the trailer for a movie.
      #
      # m     - The Cinch::Message.
      # query - The query or IMDb id as a String.
      #
      # Returns nothing.
      def trailer(m, query)
        movie = find_movie query rescue StandardError.new "#{query} not found."

        if movie.trailers.size >= 1 then
          url = movie.trailers.first[1] # movie.trailers is lame             
        else
          trailers = @youtube.videos_by(:query => "#{movie.title} trailer")
          url      = trailers.videos.first.player_url
        end
        
        m.reply @fact.call movie, 'trailer', @isgd.shorten(url).shorturl
      rescue => e
        m.reply @not_found.call query
        bot.loggers.error e.message
      end
      
      # Public: Look up some specific fact about a movie.
      #
      # m     - The Cinch::Message.
      # fact  - The fact String that needs to be searched for.
      # query - The search query or IMDb id as a String.
      #
      # Returns nothing.
      def fact(m, fact, query)
        return unless FACTS.include? fact
        
        movie  = find_movie query rescue StandardError 'not found'
        result = movie.send fact
        
        # Persons (writers, directors and actors)
        if result.kind_of? Array
          result.map! { |item| item.kind_of?(String) ? item : item.name }
          
          if result.size > 1
            commas = result.first(result.size - 1)
            result = "#{commas.join(", ")} and #{result.last}"
          else
            fact   = fact.slice(0...fact.length - 1) # the fact is plural
            result = result.first
          end
        end
        
        m.reply @fact.call movie, fact, result
      rescue => e
        m.reply @not_found.call query
        bot.loggers.error e.message
      end
      
      # Public: Look up some general information about a movie.
      #
      # m     - The Cinch::Message.
      # query - The search query or IMDb id as a String.
      #
      # Returns nothing.
      def imdb(m, query)
        movie = find_movie query
        
        m.reply @standard.call movie
      rescue => e
        m.reply @not_found.call query
        bot.loggers.error e.message
      end

      def more(m, query = nil)
        m.reply "More: http://www.imdb.com/find?q=#{URI.escape query || @last}"
      end
      
      # Internal: Finds a movie by title or IMDb id.
      #
      # query - The search query or IMDb id as a String.
      #
      # Returns a IMDbParty::Movie object.
      def find_movie(query)
        @last_query = query

        if query =~ /t{0,2}([0-9]{7})$/i
          @imdb.find_by_id query
        else
          @imdb.find_by_id @imdb.find_by_title(query).imdb_id
        end
      rescue => e
        bot.loggers.error e.message
      end
    end
  end
end
