class Release < ActiveRecord::Base
  belongs_to :download
  belongs_to :release_type
  has_many :locations, :dependent => :destroy
  
  validates_presence_of :download
  validates_associated :release_type, :locations
  
  after_destroy :delete_download_if_last_release
  
  private
  def delete_download_if_last_release
    if self.download.releases.blank?
      self.download.destroy
    end
  end
end