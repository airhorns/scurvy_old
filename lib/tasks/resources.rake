require 'find'
require 'open-uri'
require 'digest'
require "#{RAILS_ROOT}/lib/tasks/movie_maker.rb"
require "#{RAILS_ROOT}/lib/tasks/music_maker.rb"

namespace :rz do  
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