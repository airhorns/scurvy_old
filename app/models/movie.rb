class Movie < ActiveRecord::Base
  has_one :download, :as => :resource
  
  def self.per_page
    10
  end
  
end
