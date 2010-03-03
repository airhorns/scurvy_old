require 'find'
require 'open-uri'
require 'digest'
require "#{Rails.root}/lib/tasks/movie_maker.rb"
require "#{Rails.root}/lib/tasks/music_maker.rb"

namespace :rz do  
  task :add => :environment do 
    %w{movie}.each do |type|
      first = true
      total_count = 1
      existing_count = 1
      puts "Searching #{App.downloads[type.intern]} for #{type.pluralize}"
      
      Find.find(App.downloads[type.intern]) do |path|
        Find.prune if path.include?('.DS_Store')
        unless first #|| total_count > 2
          total_count = total_count + 1
          case type
            when "music"
              if ( ! File.directory?(path)) and (File.extname(path) == '.mp3')
                if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil?
                  puts "music found: #{path}"
                  music = MusicMaker.scan_path(path)
                else
                  existing_count = existing_count + 1
                  Find.prune
                end
              end
            when "movie"
              if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil?
                puts "movie dir: #{path}"
                movie = MovieMaker.add_at_path(path)
                Find.prune
                existing_count = existing_count + 1
              else
                existing_count = existing_count + 1
                Find.prune
              end
            else
          end
        else
          first = false
        end
      end
      puts "Done searching for #{type.pluralize}, #{total_count} paths scanned, #{existing_count} were already known."
    end
  end
  
  task :clean => :environment do
    # clean out locations leading to directories
    Location.find_each do |loc|
      loc.destroy if (File.directory?(loc.location) or File.basename(loc.location) == '.DS_Store')
    end
  end
  
  task :update => :environmen do 
    Movie.find_each do |movie|
    end
    Album.find_each do |movie|
      
    end
  end
  
  task :addmovie => :environment do
    MovieMaker.add_at_path(ENV['movie'])
  end
  
  task :addmusic => :environment do
    MusicMaker.scan_path(ENV['album'])
  end
  
  task :clearmusic => :environment do 
    Track.delete(:all)
    Album.delete(:all)
    Artist.delete(:all)
  end
end