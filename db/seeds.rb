# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create(:login => "hornairs", :password => "donthack", :password_confirmation=>"donthack", :email => "harry.brundage@gmail.com", :name => "Harry", :invitation_limit => 500)
ReleaseType.create(:name => "Unknown", :description => "This file is available but the quality is currently unknown.", :applies_to => "movie")
ReleaseType.create(:name => "DVD Rip", :description => "DVD Quality video ripped from a retail DVD. Best standard definition release type available.", :applies_to => "movie")
ReleaseType.create(:name => "DVD Screener", :description => "DVD Quality video ripped from a screener DVD. May have black and white scenes, overlay text, or other piracy prevention features. See release notes.", :applies_to => "movie")

ReleaseType.create(:name => "MP3 (V0-320)", :description => "Good quality MP3 files in VB0, V0 or V2 usually. Smallest file size.", :applies_to => "album")
ReleaseType.create(:name => "Lossless", :description => "Perfect sound reproduction from a lossless codec such as flac", :applies_to => "album")