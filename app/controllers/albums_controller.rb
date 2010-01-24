class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml
  before_filter :require_user
  
  autocomplete_for :album, :name do |albums|
    albums.map{|album| "#{album.name} - #{album.artist.name} --- #{album.id}"}.join("\n")
  end
  
  def index
    page = params[:page] || 1
    @albums             = Album.paginate :page => params[:page], :include => [:download], :order => 'albums.created_at DESC', :conditions => ['downloads.approved = ?', true]
    @unapproved_albums  = Album.find(:all, :limit =>15, :include => [:download], :order => 'albums.created_at DESC', :conditions => ['downloads.approved = ?', false])
    respond_to do |format|
      format.html # index.html.erb
      format.js {
        render :update do |page|
          page.replace_html 'pagelist', :partial => 'album_list', :locals => {:page_list => @album}
        end
      }
      format.xml  { render :xml => @album }
    end
    
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.js { render(:partial => 'album_details', :locals => {:album => @album})}
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.xml
  # def new
  #     @album = Album.new
  # 
  #     respond_to do |format|
  #       format.html # new.html.erb
  #       format.xml  { render :xml => @album }
  #     end
  #   end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @download = @album.download if @album
  end

  # POST /albums
  # POST /albums.xml
  # def create
  #   @album = Album.new(params[:album])
  # 
  #   respond_to do |format|
  #     if @album.save
  #       flash[:notice] = 'Album was successfully created.'
  #       format.html { redirect_to(@album) }
  #       format.xml  { render :xml => @album, :status => :created, :location => @album }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        flash[:notice] = 'Album was successfully updated.'
        format.html { redirect_to(@album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end
end
