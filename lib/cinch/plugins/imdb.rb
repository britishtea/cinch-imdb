require "rubygems"
require "bundler/setup"

require "imdb_party"

module Cinch
  module Plugins
    class Imdb
      include Cinch::Plugin
      prefix ":"
      help "Usage: :imdb [-option] The Dark Knight"

      match /imdb (?:-([\S]+)(?: ))?(.+)/i, method: :imdb

      def initialize(*args)
        super
        @imdb  = ImdbParty::Imdb.new :anonymize => true
        @facts = ['title', 'imdb_id', 'tagline', 'plot', 'runtime', 'rating',
                  'release_date', 'poster_url', 'certification', 'trailer',
                  'genres', 'writers', 'directors', 'actors']
      end

      # Returns the title, rating and plot of a movie
      def imdb(m, fact, query)
        movie = find_movie(m, query)
        
        if fact.nil?
          msg = standard_response(movie)
        elsif fact =~ /^trailer$/i # case insensitive comparison :/
          if movie.trailers.size >= 1 then
            url = "#{movie.trailers.first[1]}" # movie.trailers is lame             
          else
            url = "http://youtu.be/search?q=trailer+#{URI.escape(movie.title)}"
          end
          
          msg = fact_response(movie, fact, url)
        elsif @facts.include?(fact)
          result = movie.send(fact)
          
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
          
          unless result.nil?
            msg = fact_response(movie, fact, result)
          end
        end
        
        m.reply msg unless msg.nil?
      rescue
        puts $!
      end
      
      def standard_response(movie)
        msg  = "#{movie.title} "
        msg << "(#{movie.release_date[0, 4]})" unless movie.release_date.nil?
        msg << " - #{movie.rating}/10 " unless movie.rating.nil?
        msg << " - #{movie.runtime}" unless movie.runtime.nil?
        msg << " - http://imdb.com/title/#{movie.imdb_id}/"
        msg << "\nPlot: #{movie.plot}" unless movie.plot.nil?

        msg
      end

      def fact_response(movie, fact, result)
        "#{fact.capitalize} for #{movie.title}: #{result}"
      end

      def not_found_response(query)
        "Sorry, I can't find \"#{query}\" :("
      end

      # Returns a Movie object
      def find_movie(m, query)
        @imdb  = ImdbParty::Imdb.new
        
        unless query =~ /((?:tt)?[0-9]{7})/i
          query = @imdb.find_by_title(query).first[:imdb_id]
        end
        
        @imdb.find_movie_by_id(query)
      rescue
        m.reply not_found_response(query)
        puts $!
      end
    end
  end
end