require 'find'
require 'open-uri'
require 'digest'

IMAGE_PATH = "#{RAILS_ROOT}/public/images/posters/"
IMAGE_PATH = "#{RAILS_ROOT}/public/images/albumart/"

namespace :rz do  
  class MovieMaker
    def initialize(path)
      @path = path
      if File.directory?(@path) 
        puts "Dir: #{path}"
        search_nfos(@path)
        if @imdb
          puts "imdb from nfo: #{@imdb}"
        else
          fetch_first_imdb(File.basename(@path))
          puts "imdb from title: #{@imdb}"
        end

      else
        puts "File: #{@path}"
        fetch_first_imdb(File.basename(@path))
        puts "imdb from title: #{@imdb}"
      end
      
      @download = {:approved => false, :active => true, :created_by => 0}
      
      d = Download.new(@download)
      
      set_movie
      
      d.resource = @movie
      
      if(@genres)
          d.tag_list.add(@genres) 
      end
      
      # @todo Add in parsing of release types
      r =  Release.new(:release_type => ReleaseType.find_by_name('Unknown'))
      
      Find.find(path) do |x|
        r.locations << Location.new(:location => x)
      end
      d.releases << r
      d.save!
    end

    private
      def set_movie
        
        # Check to see if this movie is already in the DB
        if @imdb 
          @movie = Movie.find_by_imdbid(@imdb)
          if @movie
            return
          end
        end
        
        # Grab the movie's details if the IMDB ID is set
        if !@movie and @imdb
          movie = Imdb::Movie.new(@imdb)
        end
        
        # If a movie has been found, parse out it's details for our own use
        if movie   
          puts "imdb title #{movie.title}"
          movieinfo = {
            :title => movie.title,
            :year => movie.year,
            :director => movie.director.join(", ").gsub(/[^A-Za-z0-9'", ]/, ''),
            :imdbid => @imdb,
            :imdbrating => movie.rating,
            :synopsis => movie.plot,
            :tagline => movie.tagline,
            :length => movie.length,
            :autogenerated => true
          }
          
          @genres = movie.genres
          
          if movie.poster 
            #imagename = Time.now.strftime("%y%m%d%H%M%S") + @movie.title.gsub(/[^A-Za-z0-9]/,'')[0, 5] + '.jpg'
            imagename = Digest::MD5.hexdigest(@imdb) + '.jpg'
            
            open(IMAGE_PATH + imagename, 'wb') {|f| 
              f << open(movie.poster).read 
            }
          
            movieinfo[:posterurl] = "posters/"+imagename
          end
          @movie = Movie.new(movieinfo)
        else
          # If all else fails, just use an unknown movie title and mark it as a guess
          @movie_title ||= "unknown"
          movieinfo = {
            :title => @movie_title,
            :autogenerated => true
          }
          @movie = Movie.new(:title => @movie_title + " - GUESS")
        end
      end
      
      def get_title_from_filename(filename)
        title = filename.gsub(/\/|(?:readinfo|readnfo|xvid|dvdrip|dvd rip|dvdscreener|screener|dvdscr|dvd|rls|limited|ac3|fs|ws|subbed|internal|r5|bdrip|cd1|cd2|avi|wmv|xvid|divx|bluray|1080p|720p|1080i|480i|proper|dts|x\.264|x264|re.pack|rerepack).*|\[.+?\]|\*|\/$/i, '')
        title = title.gsub(/-[^\s]+?$/, '')
        title = title.gsub(/-|_|\./, ' ')
        puts "found title: #{title}"
        return title
      end

      def search_nfos(path)
        Dir.chdir(path)
        Dir['*.nfo'].each do |nfo|
          nfo = File.open(nfo, "rb").read
          if /imdb\.com\/title\/tt([0-9]+)/.match(nfo) 
            @imdb = $1
          end
        end
        @imdb = false
      end

      def fetch_first_imdb(filename)
        @title = get_title_from_filename(filename);
        search = Imdb::Search.new(@title)
        m = search.movies[0] ||= false
        if m
          @imdb = m.id
          @movie = m
          return [m.id, m.title].join(" - ")
        else 
          return false
        end
      end
  end
  
  
  task :addmovie => :environment do
    MovieMaker.new(ENV['movie'])
  end
  
  task :adddirectory => :environment do
    first = true
    count = 0
    Find.find(ENV['path']) do |x|
      count = count + 1
      if first or count > 10
        first = false
      else
        MovieMaker.new(x)
        if File.directory?(x)
          Find.prune
        end
      end
    end
    
  end
end