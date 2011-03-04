class MarketsController < ApplicationController
  # GET /markets
  # GET /markets.xml
  def index
    @markets = Market.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @markets }
    end
  end

  # GET /markets/1
  # GET /markets/1.xml
  def show
    @market = Market.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @market }
    end
  end

  # GET /markets/new
  # GET /markets/new.xml
  def new
    @market = Market.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @market }
    end
  end

  # GET /markets/1/edit
  def edit
    @market = Market.find(params[:id])
  end

  # POST /markets
  # POST /markets.xml
  def create
    @market = Market.new(params[:market])

    respond_to do |format|
      if @market.save
        format.html { redirect_to(@market, :notice => 'Market was successfully created.') }
        format.xml  { render :xml => @market, :status => :created, :location => @market }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @market.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /markets/1
  # PUT /markets/1.xml
  def update
    @market = Market.find(params[:id])

    respond_to do |format|
      if @market.update_attributes(params[:market])
        format.html { redirect_to(@market, :notice => 'Market was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @market.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.xml
  def destroy
    @market = Market.find(params[:id])
    @market.destroy

    respond_to do |format|
      format.html { redirect_to(markets_url) }
      format.xml  { head :ok }
    end
  end
end
