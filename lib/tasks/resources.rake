require 'find'
require 'open-uri'
require 'digest'
require "#{Rails.root}/lib/tasks/movie_maker.rb"
require "#{Rails.root}/lib/tasks/music_maker.rb"
require "#{Rails.root}/lib/tasks/resource_manager.rb"

namespace :rz do  
  
  task :add, :type, :path, :needs => :environment do |t, args|
    if args[:type].blank?
      App.resource_types.each {|t| ResourceManager::add_type(t)}
    else
      raise ArgumentError, "Must supply a recognized type, options are "+App.resource_types.join(',') if App.resource_types.include?(args[:type])
      raise ArgumentError, "Must supply a path to scan when supplying a type" if args[:path].blank?
      
      case args[:type]
      when "movie"
        MovieMaker.add_release_at_path(args[:path])
      when "music"
        MusicMaker.scan_path(args[:path])
      end
    end
  end
  
  task :clean => :environment do
    # clean out locations leading to directories
    Location.find_each do |loc|
      loc.destroy if (File.directory?(loc.location) or File.basename(loc.location) == '.DS_Store')
    end
  end
  
  task :update, :type, :needs => :environment do |t, args| 
    if args[:type].blank?
      App.resource_types.each {|t| ResourceManager::update_type(t)}
    else
      ResourceManager::update_type(args[:type])
    end
  end
  
  task :clear, :type, :needs => :environment do |t, args|
    if args[:type].blank?
      App.resource_types.each {|t| ResourceManager::clear_type(t)}
    else
      ResourceManager::clear_type(args[:type])
    end
  end
end

