class Download < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :resource, :polymorphic => true, :dependent => :destroy
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  has_many :releases, :dependent => :destroy
  
  validates_inclusion_of :active, :in => [true, false] 
  validates_inclusion_of :approved, :in => [true, false]
  validates_associated :releases
  validates_presence_of :resource
end