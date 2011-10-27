class BuildingsController < ApplicationController
  skip_before_filter :authorize, :only => [:index, :show, :ajax_update, :change_view_mode]
  @@TIME_OFFSET = 730.days

  # GET /buildings
  # GET /buildings.xml
  def index
	session[:view_mode] = "basic"
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
	params[:on_show_page] = true
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
		info[:monthly] = 255
		@building.meters.each do |meter|
			#info[:daily] = (Time.now - @@TIME_OFFSET).year
			#info[:current] = "CALL powerstorm_data.getSumOfMonthForMeter(#{meter.id},#{(Time.now - @@TIME_OFFSET).year},#{(Time.now - @@TIME_OFFSET).month});"
			info[:monthly] += Building.connection.execute("CALL powerstorm_data.getSumOfMonthForMeter(#{meter.id},#{(Time.now - @@TIME_OFFSET).year},#{(Time.now - @@TIME_OFFSET).month});").first[1]

		#puts Building.connection.execute("SELECT power FROM `powerstorm_data`.`electricity_readings` where id=61;").first
			
			
		#	info[:monthly] += meter.electricity_readings.connection.execute("SELECT MONTH(date_time) AS h, SUM(power) AS s
		#		FROM powerstorm_data.electricity_readings
		#		WHERE YEAR(date_time)=#{(Time.now - @TIME_OFFSET).year}
		#		GROUP BY MONTH(date_time)
		#		HAVING h=#{(Time.now - @TIME_OFFSET).month};")
		end

=begin
		info[:daily] = (Time.now - @@TIME_OFFSET).day
		info[:monthly] = (Time.now - @@TIME_OFFSET).month
		info[:yearly] = (Time.now - @@TIME_OFFSET).year
=end
	end
	
    respond_to do |format|
      format.json { render :json => info }
    end
  end
  
  def change_view_mode
	session[:view_mode] = params[:view_mode]
    respond_to do |format|
	  format.html { redirect_to(request.referer) }
	end
  end  
end
