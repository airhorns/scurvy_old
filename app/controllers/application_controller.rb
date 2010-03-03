# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  before_filter :check_for_maintenance
  before_filter :tagline
  before_filter :fetch_release_types, :only => [:edit, :update]
  
  
  private
    def check_for_maintenance
        if File.exist? "#{Rails.root}/public/maintenance.html"
          return render(:file => "#{Rails.root}/public/maintenance.html") unless App['active']
       end
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def tagline
      if !session[:tagline]
        a = [
          "sliced bread pales in comparison to scurvy.",
          "scurvy is chuck norris' favourite web site.",
          "the disease, and the website, is no laughing matter.",
          "scurvy: make sure your limbs don't fall off.",
          "drink more oj.",
          "really bad eggs, but really good files.",
          "almost as good looking as roger's mom.",
          "got any suggestions to make scurvy better? let harry know.",
          "got any requests for files? let harry know.",
          "I like it. Simple, easy to remember."]
        session[:tagline] = a[rand(a.length)]
      end
      @tagline = session[:tagline]
    end
    
    def fetch_release_types
      @release_types = ReleaseType.find(:all, :conditions => ['release_types.applies_to = ? OR ?', 'movie', nil])
    end
end
