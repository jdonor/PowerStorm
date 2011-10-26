class BuildingsController < ApplicationController
  skip_before_filter :authorize, :only => [:index, :show, :ajax_update]

  # GET /buildings
  # GET /buildings.xml
  def index
    @buildings = Building.all
    @logged_out = User.find_by_id(session[:user_id]).nil?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.xml
  def show
    if params[:abbreviation]
      @building = Building.where(:abbreviation => params[:abbreviation]).first
    else
      @building = Building.find(params[:id])
    end

    respond_to do |format|
      format.js { render :json => @building }
      format.html # show.html.erb
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.xml
  def new
    @building = Building.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/1/edit
  def edit
    @building = Building.find(params[:id])
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    @building = Building.new(params[:building])

    respond_to do |format|
      if @building.save
        format.html { redirect_to(@building, :notice => 'Building was successfully created.') }
        format.xml  { render :xml => @building, :status => :created, :location => @building }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    @building = Building.find(params[:id])

    respond_to do |format|
      if @building.update_attributes(params[:building])
        format.html { redirect_to(@building, :notice => 'Building was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    respond_to do |format|
      format.html { redirect_to(buildings_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_update
    @building = Building.where(:abbreviation => params[:building]).first
    
	info = {:current => 0, :max => 0, :monthly => 0, :daily => 0, :hourly => 0}
	
	if params[:type] == "update"
		@building.meters.each do |meter|
			info[:max] += meter.electricity_readings.order(:power).reverse_order.first.power
			info[:current] += meter.electricity_readings.order(:date_time).reverse_order.first.power
		end
	else
		@building.meters.each do |meter|
			by_month = meter.electricity_readings.group_by { |t| t.date_time.beginning_of_month }
			
		end
	end
	
	
    respond_to do |format|
      format.json { render :json => info }
    end
  end
end
