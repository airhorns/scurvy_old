class Release < ActiveRecord::Base
  belongs_to :download
  belongs_to :release_type
  has_many :locations
end
