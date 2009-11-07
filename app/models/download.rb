class Download < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :resource, :polymorphic => true
  has_many :locations
  has_many :releases
end
