class Movie < ActiveRecord::Base
  acts_as_taggable
  has_one :download, :as => :resource
  
  validates_associated :download  
  validates_presence_of :title
  validates_numericality_of :year, :allow_nil => true
  validates_numericality_of :imdbid, :allow_nil => true
  validates_numericality_of :imdbrating, :allow_nil => true
  validates_url_format_of :posterurl, :allow_nil => true
  
  validates_inclusion_of :autogenerated, :in => [true, false]
    
  attr_accessor :genres
  
  def self.per_page
    15
  end
  
  def self.from_imdb(imdbid)
    # Check to see if this movie is already in the DB. Warning: IMDBID must be known to be valid, lame.
    imdbid = imdbid.id if imdbid.class == Imdb::Movie
    movie = Movie.find_by_imdbid(imdbid)
    if movie.nil?
      movie = Movie.new_from_imdb(imdbid) 
    end
    movie
  end
  
  def self.new_from_imdb(imdbid)
    imdb = Imdb::Movie.new(imdbid)
    
  # If a movie has been found on IMDB, parse out it's details for our own use
    puts "imdb record title #{imdb.title}"
    movieinfo = {
      :title => imdb.title,
      :year => imdb.year,
      :director => imdb.director.join(", ").gsub(/[^A-Za-z0-9'", ]/, ''),
      :imdbid => imdbid,
      :imdbrating => imdb.rating,
      :synopsis => imdb.plot,
      :tagline => imdb.tagline,
      :length => imdb.length,
      :autogenerated => true
    }
    
    if imdb.poster && false
      imagename = Digest::MD5.hexdigest(@imdb) + '.jpg'
      
      open(IMAGE_PATH + imagename, 'wb') {|f| 
        f << open(movie.poster).read 
      }
    
      movieinfo[:posterurl] = "posters/"+imagename
    end
    
    movie = Movie.new(movieinfo)
    movie.genres = imdb.genres
    movie
  end
end
