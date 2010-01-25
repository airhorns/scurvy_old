class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  before_filter :latest_movies, :require_user
  
  autocomplete_for :movie, :title do |movies|
    movies.map{|movie| "#{movie.title} (#{movie.year}) --- #{movie.id}"}.join("\n")
  end
  
  def index
    page = params[:page] || 1
    @movies             = Movie.paginate :page => params[:movie_page], :include => [ :download ], :order => 'movies.created_at DESC', :conditions => ['downloads.approved = ?', true]
    @unapproved_movies  = Movie.paginate :page => params[:unapproved_page], :include => [ :download ], :order => 'movies.created_at DESC', :conditions => ['downloads.approved = ?', false]
    
    respond_to do |format|
      format.html # index.html.erb
      format.js {
        render :update do |page|
          page.replace_html 'movielist', :partial => 'movie_list', :locals => {:movie_list => @movies}
        end
      }
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])
    
    respond_to do |format| 
      format.js { render(:partial => 'movie_details', :locals => {:movie => @movie})}
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
    @download = @movie.download if @movie
  end
  
  def imdb
    @movie = Movie.find(params[:id])
    respond_to do |format| 
      format.js { render(:partial => 'imdb')}
      format.xml  { render :xml => @movie }
    end
  end
  
  # POST /movies
  # POST /movies.xml
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        flash[:notice] = 'Movie was successfully created.'
        format.html { redirect_to(@movie) }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])
    @download = @movie.download if @movie

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(movies_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def imdbfetch
    @movie = Movie.find(params[:id])
    @imdb_movie = Imdb::Movie.new(params[:movie][:imdbid])
    @autoupdate = params[:autoupdate] ||= false
    
    render :update do |page|
      if !@imdb_movie.nil?
        if @autoupdate
          #haven't done this yet
        end
        page.replace_html 'imdbresults', :partial => 'imdb_movie'
      else
        page.replace_html 'imdbresults', "No IMDB film found."
      end
    end
  end
  
  private
  def latest_movies
    @latest_movies = Movie.find(:all, :include => [:download], :limit => 5, :order => 'movies.created_at DESC', :conditions => ['downloads.approved = ?', true])
  end
  
end
