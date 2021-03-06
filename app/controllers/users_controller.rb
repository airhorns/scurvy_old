class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  before_filter :require_valid_invitation, :only => [:new, :create] 
  
  def new 
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
    render :layout => "user_sessions"
  end
  
  def create
    @user = User.new(params[:user])
    @user.invitation.used = true if @user.invitation
    if @user.save
      flash[:success] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new, :layout => "user_sessions"
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:success] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  private
  
  def require_valid_invitation
    if ! params[:invitation_token].nil?
      invite = Invitation.find_by_token(params[:invitation_token])
    elsif ! params[:user].nil? and ! params[:user][:invitation_token].nil?
      invite = Invitation.find_by_token(params[:user][:invitation_token])
    end
    if invite.nil? or invite.used == true
      flash[:error] = "Invalid invitation code."
      redirect_to login_url
    end
  end
end
