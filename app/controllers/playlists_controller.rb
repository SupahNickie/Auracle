class PlaylistsController < ApplicationController
  before_filter :set_user, except: [:try, :trial_create]
  before_action :set_playlist, only: [:show, :edit, :update, :destroy,
                                      :whitelist, :blacklist, :unblacklist, :unwhitelist,
                                      :view_blacklist, :list]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = @user.playlists.all
    authorize @playlists
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    authorize @playlist
    @playlist.find_music(@playlist, @playlist.mood, @playlist.timbre, @playlist.intensity, @playlist.tone,
      @playlist.scope, "shuffle")
    @playlist.songs_list.sort_by! {|x| [x.album.band.username, x.album.title, x.title]} if Rails.env.test?
  end

  # GET /playlists/new
  def new
    @playlist = @user.playlists.new
    authorize @playlist
  end

  def try
    @playlist = guest_user.playlists.new
  end

  def trial_create
    @playlist = guest_user.playlists.new(playlist_params)
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to "/users/#{guest_user.to_param}/playlists/#{@playlist.id}", notice: 'We hope you enjoy trying Auracle!' }
      else
        format.html { render action: 'try' }
      end
    end
  end

  # GET /playlists/1/edit
  def edit
    authorize @playlist
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = @user.playlists.new(playlist_params)
    authorize @playlist

    respond_to do |format|
      if @playlist.save
        if current_user && current_user.role == "band"
          format.html { redirect_to user_playlist_path(@user, @playlist), notice: 'Playlist was successfully created!' }
        elsif current_user && current_user.role == "personal"
          format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}", notice: 'Playlist was successfully created!' }
        else
          format.html { redirect_to "/users/#{guest_user.to_param}/playlists/#{@playlist.id}", notice: 'We hope you enjoy trying Auracle!' }
        end
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    authorize @playlist

    respond_to do |format|
      if @playlist.update(playlist_params)
        if current_user.role == "band"
          format.html { redirect_to user_playlist_path(@user, @playlist), notice: 'Playlist was successfully updated!' }
        else
          format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}", notice: 'Playlist was successfully updated!' }
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    authorize @playlist

    @playlist.destroy
    respond_to do |format|
      if current_user.role == "band"
        format.html { redirect_to user_playlists_path(@user), notice: 'Playlist was successfully deleted!' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/users/#{current_user.to_param}/playlists", notice: 'Playlist was successfully deleted!' }
        format.json { head :no_content }
      end
    end
  end

  def whitelist
    authorize @playlist

    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "add")
    unless current_user.ratings.include? @song.id
      @song.add_attributes_to_array(@song, @song.average_mood, @song.average_timbre, @song.average_intensity, @song.average_tone)
      @song.new_average(@song)
      current_user.push_song_id_to_ratings_list(@song, current_user)
    end
    respond_to do |format|
      if current_user.role == "band"
        format.html { redirect_to view_blacklist_user_playlist_path(@user, @playlist), notice: 'Song was successfully favorited to this playlist!' }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}/view_blacklist", notice: 'Song was successfully favorited to this playlist!' }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def blacklist
    authorize @playlist

    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "remove")
    respond_to do |format|
      if current_user.role == "band"
        if current_user.ratings.include? @song.id
          format.html { render :text => '<script type="text/javascript">window.open("", "_self", ""); window.close();</script>' }
        else
          format.html { redirect_to rating_user_album_song_path(@user, @song.album, @song, playlist_id: @playlist.id), notice: 'Song was successfully removed from this playlist!' }
          format.json { head :no_content }
          format.js
        end
      else
        if current_user.ratings.include? @song.id
          format.html { render :text => '<script type="text/javascript">window.open("", "_self", ""); window.close();</script>' }
        else
          format.html { redirect_to "/artists/#{@song.album.band.to_param}/albums/#{@song.album.to_param}/songs/#{@song.to_param}/rating?playlist_id=#{@playlist.id}", notice: 'Song was successfully removed from this playlist!' }
          format.json { head :no_content }
          format.js
        end
      end
    end
  end

  def unblacklist
    authorize @playlist

    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "unblacklist")
    respond_to do |format|
      if current_user.role == "band"
        format.html { redirect_to view_blacklist_user_playlist_path(@user, @playlist), notice: 'Song was successfully given another chance!' }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}/view_blacklist", notice: 'Song was successfully given another chance!' }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def unwhitelist
    authorize @playlist

    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "unwhitelist")
    respond_to do |format|
      if current_user.role == "band"
        format.html { redirect_to view_blacklist_user_playlist_path(@user, @playlist), notice: 'Song was successfully unfavorited!' }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}/view_blacklist", notice: 'Song was successfully unfavorited!' }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def view_blacklist
    authorize @playlist
  end

  def list
    @playlist.find_music(@playlist, @playlist.mood, @playlist.timbre, @playlist.intensity, @playlist.tone,
      @playlist.scope, "order")
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = @user.playlists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :mood, :timbre, :intensity, :tone, :songs_list, :user_id, :whitelist, :blacklist, :scope, :invisible)
    end
end
