class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
  has_one :download, :as => :resource
  
  validates_presence_of :name
  validates_associated :download
  validates_numericality_of :listeners, :allow_nil => true
  validates_url_format_of :url, :allow_nil => true
  validates_url_format_of :image_url, :allow_nil => true
#  validate :release_date_is_date
  
  attr_accessor :scrobble_record
  
  class << self
    def per_page
      15
    end
    
    def new_from_scrobbler(album, artist = nil, autogenerated = true)
      raise ArgumentError, "Album must be of type Scrobbler::Album" if album.class != Scrobbler::Album
      artist = Artist.from_scrobbler(album.artist) if artist.nil?
      r_album = Album.new(:name => album.name, :url => album.url, :lastfm_id => album.album_id, :listeners => album.listeners, :mb_id => artist.mb_id, :artist => artist, :image_url=> album.image_large, :release_date => album.release_date, :autogenerated => autogenerated)
      r_album.scrobble_record = album
      r_album
    end
  
    def from_scrobbler(album, artist = nil)
      raise ArgumentError, "Album must be of type Scrobbler::Album" if album.class != Scrobbler::Album
      r_album = Album.find_by_lastfm_id(album.album_id) if album.album_id
      if r_album.nil?
        r_album = Album.new_from_scrobbler(album, artist)
      end
      r_album
    end
    
    def new_from_id3tag(tag)
      album = Scrobbler::Album.new(tag.artist, tag.album , :include_info => true)
      artist = Artist.from_id3tag(tag)
      Album.from_scrobbler(album, artist)
    end
    
    def from_id3tag(tag)
      album = Album.find(:first, :include => [:artist], :conditions => {:name => tag.album, :artists => {:name => tag.artist}})         
      if album.nil?
        album = Album.new_from_id3tag(tag)
      end
      album
    end
  end
  
  private
  def release_date_is_date
    if !release_date.nil?
      errors.add_to_base("Release date must be of type date") unless release_date.class == Time
    end
  end
end