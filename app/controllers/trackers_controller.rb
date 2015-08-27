class TrackersController < ApplicationController
	
  before_action :set_tracker, only: [:show, :edit, :update, :destroy]

  # GET /trackers
  # GET /trackers.json
  def index
	@trackers = Tracker.all
  end

  # GET /trackers/1
  # GET /trackers/1.json
  def show
	@tracker = Tracker.find(params[:id]) 
	@modifications = @tracker.modifications 
  end
	
	def modifications
		@tracker = Tracker.find(params[:id]) 
		@modifications = @tracker.modifications 
	end	

  # GET /trackers/new
	def new
		session[:tracker_params] ||= {}
		@tracker = Tracker.new(session[:tracker_params])
		@tracker.current_step = session[:tracker_step]
	end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers
  # POST /trackers.json
	def create
		session[:tracker_params].deep_merge!(params[:tracker]) if params[:tracker]
		@tracker = Tracker.new(session[:tracker_params])
		@tracker.current_step = session[:tracker_step]
		
	  if @tracker.valid?
		if params[:back_button]
	  		@tracker.previous_step
		elsif @tracker.last_step?
	  		@tracker.save if @tracker.all_valid?
		else
	  		@tracker.next_step
		end
		session[:tracker_step] = @tracker.current_step
	  end
		
	  if @tracker.new_record?
		render "new"
	  else
		session[:tracker_step] = session[:tracker_params] = nil
		flash[:notice] = "Tracker saved!"
		redirect_to @tracker
		  
		Modification.create(date: DateTime.now, content: @tracker.content, Tracker_id: @tracker.id)
	  end
	end
	
  # PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to @tracker, notice: 'Tracker was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracker }
      else
        format.html { render :edit }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackers/1
  # DELETE /trackers/1.json
  def destroy
	@tracker.destroy
	@tracker.modifications.destroy_all #destroys all associations
	  
    respond_to do |format|
      format.html { redirect_to trackers_url, notice: 'Tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
		@tracker = Tracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
		params.require(:tracker).permit(:url, :nodes, :content)
    end
end
