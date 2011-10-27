class BuildingsController < ApplicationController
  skip_before_filter :authorize, :only => [:index, :show, :ajax_update, :change_view_mode]
  @@TIME_OFFSET = 365.days

  # GET /buildings
  # GET /buildings.xml
  def index
	session[:view_mode] = "basic" if session[:view_mode].nil?
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
	session[:view_mode] = "basic" if session[:view_mode].nil?
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
  
  def send_chart info, period, building_id, from_date, to_date
	#puts(" |||||||||||||||||||  CALL chartBy#{period}(#{building_id}, '#{from_date}', '#{to_date}');")
	info[:result] = Building.connection.execute("CALL powerstorm_data.chartBy#{period}(#{building_id}, '#{from_date}', '#{to_date}');").to_a.transpose.first.collect { |i| (i * 100).to_i / 100.0 }
  end
  
  def ajax_update
    @building = Building.where(:abbreviation => params[:building]).first

	info = {:min => 0, :max => 0, :current => 0, :hourly => 0, :daily => 0, :monthly => 0, :yearly => 0, :sqft => 0, :occupants => 0}
	
	info[:sqft] = @building.area
	info[:occupants] = @building.capacity
	
	if params[:type] == "update"
		@building.meters.each do |meter|
			info[:min] += meter.electricity_readings.order(:power).first.power
			info[:max] += meter.electricity_readings.order(:power).reverse_order.first.power
			info[:current] += (meter.electricity_readings.order(:date_time).reverse_order.first.power * 100).to_i / 100
		end
	elsif ["Day", "Month", "Year", "Hour", "Week"].include?(params[:type]) 
		#Date.parse(params[:from])
		#info[:result] = Building.connection.execute("CALL chartByHour(11, '2009-10-25 18:44:11', '2009-10-26 18:44:11');").to_a.transpose.first;
		#Building.find(11).connection.execute("CALL chartByHour(11, '2009-10-25 18:44:11', '2009-10-26 18:44:11');").to_a.transpose.first
		send_chart(info, params[:type], @building.id, params[:from], params[:to])

	else
		#puts("||||||||||||||||         CALL powerstorm_data.getSumsForBuilding(#{@building.id},'#{(Time.now - @@TIME_OFFSET).to_s(:db)}')")
		arr = Building.connection.execute("CALL powerstorm_data.getSumsForBuilding(#{@building.id},'#{(Time.now - @@TIME_OFFSET).to_s(:db)}')").first;
		info[:hourly] = arr[3]
		info[:daily] = arr[2]
		info[:monthly] = arr[1]
		info[:yearly] = arr[0]
		puts(">>>>>>>>>>>>>" + info.inspect)
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
