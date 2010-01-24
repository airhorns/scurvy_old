class Location < ActiveRecord::Base
  
  belongs_to :release
  validate do |location|
    errors.add_to_base("File must exist at location specified") unless File.exist?(location.location)
  end
    
end
