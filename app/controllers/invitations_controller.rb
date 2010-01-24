class InvitationsController < ApplicationController
  
  def new
    if current_user.invitation_limit > 0
      @invitation = Invitation.new
    else
      flash[:error] = "You have no more invitations to send."
      redirect_to invitations_url
    end
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sent_at = DateTime.now
    @invitation.sender = current_user
    if @invitation.save
        @invitation.send_invitation_email(signup_url(@invitation))
        flash[:notice] = "Thank you, invitation sent."
        redirect_to invitations_url
    else
      render :action => 'new'
    end
  end
  
  def index
    @invitation = Invitation.new
    @invitations = Invitation.paginate :page => params[:page], :conditions => {:sender_id => current_user}
  end
  
  def destroy
    @invite = Invitation.new(params[:id])
    if @invite.destroy
      flash[:notice] = "Invitation revoked."
    else
      flash[:error] = "Invitation couldn't be deleted."
    end
    respond_to do |format|
      format.html { redirect_to(invitations_url) }
      format.xml  { head :ok }
    end
  end
  
  def resend
    @invitation = Invitation.find(params[:id])
    if @invitation.sent_at < (DateTime.now - 3.hours)
      @invitation.send_invitation_email(signup_url(@invitation))
      flash[:success] = "Invitation resent."
    else
      flash[:error] = "It's too soon after the last time this invite was sent to send it again. Please wait at least 3 hours or contact an administrator."
    end
    redirect_to invitations_url
  end
end
