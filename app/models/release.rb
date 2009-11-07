class Release < ActiveRecord::Base
  belongs_to :download
  belongs_to :release_type
end
