require 'find'
require 'open-uri'
require 'digest'
require "#{RAILS_ROOT}/lib/tasks/movie_maker.rb"
require "#{RAILS_ROOT}/lib/tasks/music_maker.rb"

namespace :rz do  
  task :add => :environment do 
    %w{music movie}.each do |type|
      first = true
      i = 0
      total_count = 0
      existing_count = 1
      puts "Searching #{App.downloads(type)} for #{type.pluralize}"
      
      Find.find(App.downloads(type)) do |path|
        total_count = total_count + 1
        unless first
     #     i = i + 1
          case type
            when "music"
              unless File.directory?(path)
                if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil? and i < 3
                  puts "music found: #{path}"
                  music = MusicMaker.scan_path(path)
                else
                  existing_count = existing_count + 1
                  Find.prune
                end
              end
            when "movie"
              if Location.find_by_location(path).nil? and Release.find_by_root_path(path).nil? and i < 3
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
  
  task :addmovie => :environment do
    MovieMaker.scan_path(ENV['movie'])
  end
  
  task :addmusic => :environment do
    MusicMaker.scan_path(ENV['album'])
  end
  
  task :clearmusic => :environment do 
    Track.delete(:all)
    Album.delete(:all)
    Artist.delete(:all)
  end
  
  task :adddirectory => :environment do
    #only goes down one level,
    first = true
    count = 0
    Find.find(ENV['path']) do |x|
      count = count + 1
      if first or count > 10
        first = false
      else
        MovieMaker.scan_path(x)
        if File.directory?(x)
          Find.prune
        end
      end
    end
  end
end