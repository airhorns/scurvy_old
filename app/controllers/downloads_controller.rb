class DownloadsController < ApplicationController
  include Escape
  
  def index
    @downloads = Download.paginate :page => params[:page], :include => [ :resource ], :order => 'downloads.created_at DESC', :conditions => ['downloads.approved = ?', false]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @downloads }
    end
  end
  
  def edit
    @download = Download.find(params[:id])
  end

  
  def update
    @download = Download.find(params[:id])

    respond_to do |format|
      if @download.update_attributes(params[:download])
        format.js { render(:partial => 'xhrsuccess')}
        format.html { 
          flash[:notice] = 'Download was successfully updated.'
          redirect_to(@download) 
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @download.errors, :status => :unprocessable_entity }
        format.js { render(:partial => 'xhrfailure')}        
      end
    end
  end
  
  def approve 
    @download = Download.find(params[:id])
    @download.approved = true
    respond_to do |format|
      if @download.save
        format.js { render(:partial => 'xhrsuccess')}
        format.html { 
          flash[:notice] = 'Download was successfully updated.'
          redirect_to(downloads_path) 
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @download.errors, :status => :unprocessable_entity }
        format.js { render(:partial => 'xhrfailure')}        
      end
    end
  end 
     
  def download_file
    @location = Location.find(params[:id])
    send_file @location.location unless @location.nil?
  end
  
  def download_release
    @release = Release.find(params[:id])
    # unless (@release.nil? || @release.locations.blank?)
    #   cmd = Escape.shell_command(['tar -cfz'] | @release.locations.collect {|loc| loc.location})
    #   IO.popen(cmd, 'r') {|pipe|
    #     send_data pipe, :filename => "scurvy.tgz"
    #   }
    # end
    render :layout => 'barebones'
  end
  
  # def show
  #     @download = Download.find(params[:id])
  # 
  #     respond_to do |format|
  #       format.html # show.html.erb
  #       format.xml  { render :xml => @download }
  #     end
  #   end
  # 
  #   def new
  #     @download = Download.new
  # 
  #     respond_to do |format|
  #       format.html # new.html.erb
  #       format.xml  { render :xml => @download }
  #     end
  #   end
  # def create
  #     @download = Download.new(params[:download])
  # 
  #     respond_to do |format|
  #       if @download.save
  #         flash[:notice] = 'Download was successfully created.'
  #         format.html { redirect_to(@download) }
  #         format.xml  { render :xml => @download, :status => :created, :location => @download }
  #       else
  #         format.html { render :action => "new" }
  #         format.xml  { render :xml => @download.errors, :status => :unprocessable_entity }
  #       end
  #     end
  #   end
    
  # def destroy
  #     @download = Download.find(params[:id])
  #     @download.destroy
  # 
  #     respond_to do |format|
  #       format.html { redirect_to(admin_downloads_url) }
  #       format.xml  { head :ok }
  #     end
  #   end
  #
end