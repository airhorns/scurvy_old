class Artist < ActiveRecord::Base
    has_many :albums
    has_many :tracks
    attr_accessor :scrobble_record
    
    validates_presence_of :name
    validates_url_format_of :url, :allow_nil => true
    validates_url_format_of :image_url, :allow_nil => true
    validates_numericality_of :listeners, :allow_nil => true
    
    class << self
      def new_from_scrobbler(artist, autogenerated = true)
        raise ArgumentError, "Artist must be of type Scrobbler::Artist" if artist.class != Scrobbler::Artist
        r_artist = Artist.new(:name => artist.name, :url => artist.url, :mb_id => artist.mbid, :autogenerated => autogenerated)
        r_artist.scrobble_record = artist
        r_artist
      end
    
      def from_scrobbler(artist)
        raise ArgumentError, "Artist must be of type Scrobbler::Artist" if artist.class != Scrobbler::Artist
        r_artist = Artist.find_by_name(artist.name)
        if r_artist.nil?
          r_artist = Artist.new_from_scrobbler(artist)
        end
        r_artist
      end
      
      def new_from_id3tag(tag)
        artist = Scrobbler::Artist.new(tag.artist, :include_info => true)
        Artist.from_scrobbler(artist)
      end
      
      def from_id3tag(tag)
        artist = Artist.find(:first, :conditions => {:name => tag.artist})
        if artist.nil?
          artist = Artist.new_from_id3tag(tag)
        end
        artist
      end
    end
end