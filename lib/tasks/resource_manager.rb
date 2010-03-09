module ResourceManager
  def self.clear_type(type)
    case type
    when "music"
      Track.delete(:all)
      Album.delete(:all)
      Artist.delete(:all)
    when "movie"
      Movie.delete(:all)
    end
  end

  def self.add_type(type)
    first                    = true
    total_count              = 1
    existing_count           = 1
    puts "Searching #{App.downloads[type.intern]} for #{type.pluralize}"
    Find.find(App.downloads[type.intern]) do |path|
      Find.prune if path.include?('.DS_Store') # get rid of DS_Store shit

      unless first #|| total_count > 2
        total_count          = total_count + 1

        case type  
        when "music"
          if ( ! File.directory?(path)) and (File.extname(path) == '.mp3' || File.extname(path) == '.flac') # Check to see if file is music
            if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil? # Check to see if file is already in system
              puts "music loc: #{path}"
              music          = MusicMaker.add_track_at_path(path) # Have MusicMaker add this file we know as a track
            else
              existing_count = existing_count + 1
              Find.prune
            end
          end

        when "movie"
          if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil? # Check to see if file is already in system
            puts "movie loc: #{path}"
            movie            = MovieMaker.add_release_at_path(path) # Have MovieMaker search this directory or file
            Find.prune # MovieMaker scans the rest of this release's root path (to search for nfos and stuff), move on to the next root dir/file
          else
            existing_count   = existing_count + 1
            Find.prune
          end  
        end
      else
        first = false
      end
    end
    puts "Done searching for #{type.pluralize}, #{total_count} paths scanned, #{existing_count} were already known."
  end

  def self.update_type(type)
  end
end