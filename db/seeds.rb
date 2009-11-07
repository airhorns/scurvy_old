# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create(:login => "hornairs", "password" => "donthack", "password_confirmation"=>"donthack")
ReleaseType.create(:type => "Unknown", :description => "This file is available but the quality is currently unknown.", :applies_to => "movie")
ReleaseType.create(:type => "DVD Rip", :description => "DVD Quality video ripped from a retail DVD. Best standard definition release type available.", :applies_to => "movie")
ReleaseType.create(:type => "DVD Screener", :description => "DVD Quality video ripped from a screener DVD. May have black and white scenes, overlay text, or other piracy prevention features. See release notes.", :applies_to => "movie")