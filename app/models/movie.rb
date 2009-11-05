class Movie < ActiveRecord::Base
  has_one :download, :as => :resource
end
