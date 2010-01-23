class ReleaseType < ActiveRecord::Base
  has_many :releases
  validates_length_of :name, :maximum => 30
  validates_presence_of :applies_to
end