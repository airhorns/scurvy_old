require 'find'
require 'open-uri'
require 'digest'
require "#{RAILS_ROOT}/lib/tasks/movie_maker.rb"
require "#{RAILS_ROOT}/lib/tasks/music_maker.rb"

namespace :rz do  
  task :add => :environment do 
    %w{music movies}.each do |type|
      first = true
      count = 0
      path_count = 0
      puts "Searching #{App.downloads(type)} for #{type.pluralize}"
      Find.find(App.downloads(type)) do |path|
        path_count = path_count + 1
        unless first
          if Location.find_by_location(path).nil? and count < 10
            count = count + 1
            puts "#{type}: #{path}"
            Object.const_get(type.capitalize+"Maker").scan_path(path)
          else
            Find.prune
          end
        else
          first = false
        end
      end
      puts "Done searching for #{type.pluralize}, #{path_count} paths scanned."
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