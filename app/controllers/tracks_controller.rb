class TracksController < ApplicationController
  # GET /tracks
  # GET /tracks.xml
  before_filter :require_user
  
  autocomplete_for :track, :name do |tracks|
    tracks.map{|track| "#{track.name} - #{track.artist.name} --- #{track.id}"}.join("\n")
  end
  
  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end
  # PUT /tracks/1
  # PUT /tracks/1.xml
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        flash[:notice] = 'Track was successfully updated.'
        format.html { redirect_to(@track) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @track.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.xml
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to(tracks_url) }
      format.xml  { head :ok }
    end
  end
end
