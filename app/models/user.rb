class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  
  validates_presence_of :name
  validates_presence_of :login
  validates_length_of :login, :within => 1..40
  validates_uniqueness_of :login, :case_sensitive => false
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates_numericality_of :invitation_limit, :greater_than_or_equal_to => 0

  before_validation :set_invitation_limit
  after_create :use_invitation
  
  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  private

  def set_invitation_limit
    self.invitation_limit = 0 if self.invitation_limit.nil?
  end
  
  def use_invitation
    self.invitation.used = true if self.invitation
  end
end
