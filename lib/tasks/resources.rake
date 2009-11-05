require 'find'
require 'open-uri'
require 'digest'

IMAGE_PATH = "/Users/hornairs/Sites/scurvy/public/images/posters/"

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
      if @imdb
        retrieve_info
      else
        if(@movie_title)
          @movieinfo = {
            :title => @movie.title,
            :autogenerated => true
            }
        end
      end
      
      d = Download.new(@download)
      if(@movieinfo)
        d.resource = Movie.new(@movieinfo)
        d.tag_list.add(@genres)
      else 
        @movie_title ||= "unknown"
        d.resource = Movie.new(:title => @movie_title+" - GUESS")
      end
      
      Find.find(path) do |x|
        d.locations << Location.new(:location => x)
      end
      d.save!
    end

    private
      def retrieve_info
        if !@movie and @imdb
          @movie = Imdb::Movie.new(@imdb)
        end
        if @movie
          puts "imdb title #{@movie.title}"
          @movieinfo = {
            :title => @movie.title,
            :year => @movie.year,
            :director => @movie.director.join(", ").gsub(/[^A-Za-z0-9'", ]/, ''),
            :imdbid => @imdb,
            :imdbrating => @movie.rating,
            :synopsis => @movie.plot,
            :tagline => @movie.tagline,
            :length => @movie.length,
            :autogenerated => true
            }
          @genres = @movie.genres
          if @movie.poster 
            #imagename = Time.now.strftime("%y%m%d%H%M%S") + @movie.title.gsub(/[^A-Za-z0-9]/,'')[0, 5] + '.jpg'
            imagename = Digest::MD5.hexdigest(@imdb) + '.jpg'
            
            open(IMAGE_PATH + imagename, 'wb') {|f| 
              f << open(@movie.poster).read 
            }
          
            @movieinfo[:posterurl] = "posters/"+imagename
          end
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
      if first
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