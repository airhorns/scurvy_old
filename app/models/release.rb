class Release < ActiveRecord::Base
  belongs_to :download
  belongs_to :release_type
  has_many :locations
  
  validates_presence_of :download
  validates_associated :release_type, :locations
  
end