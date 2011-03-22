class OrderListingsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  before_filter :load_order_list
  before_filter :load_product_families_and_products
  
  # GET /order_listings
  # GET /order_listings.xml
  def index
    @order_listings = OrderListing.paginate(:page => params[:page], :conditions => ["product_family_id = ? and order_list_id = ?",@product_family.id, @order_list.id])
    @title = "Order Listings"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @order_listings }
    end
  end

  # GET /order_listings/1
  # GET /order_listings/1.xml
  def show
    @order_listing = OrderListing.find(params[:id])
    @title = "Order Listing"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order_listing }
    end
  end

  # GET /order_listings/new
  # GET /order_listings/new.xml
  def new
    @order_listing = @order_list.order_listings.build
    @title = "New Order Listing"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order_listing }
    end
  end

  # GET /order_listings/1/edit
  def edit
    @order_listing = OrderListing.find(params[:id])
    @title = "Edit Order Listing"
  end

  # POST /order_listings
  # POST /order_listings.xml
  def create
    @order_listing = OrderListing.new(params[:order_listing].merge(:order_list_id => @order_list.id,:product_family_id => @product_family.id))

    respond_to do |format|
      if @order_listing.save
        flash[:success] = 'Order listing was successfully created.'
        format.html { redirect_to(order_list_product_family_order_listings_path(@order_list,@product_family) }
        format.xml  { render :xml => @order_listing, :status => :created, :location => @order_listing }
      else
        @title = "New Order Listing"
        format.html { render :action => "new" }
        format.xml  { render :xml => @order_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /order_listings/1
  # PUT /order_listings/1.xml
  def update
    @order_listing = OrderListing.find(params[:id])

    respond_to do |format|
      if @order_listing.update_attributes(params[:order_listing])
        flash[:success] = 'Order listing was successfully updated.'
        format.html { redirect_to(order_list_product_family_order_listings_path(@order_list,@product_family) }
        format.xml  { head :ok }
      else
        @title = "Edit Order Listing"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /order_listings/1
  # DELETE /order_listings/1.xml
  def destroy
    @order_listing = OrderListing.find(params[:id])
    @order_listing.destroy

    respond_to do |format|
      format.html { redirect_to(order_list_product_family_order_listings_url(@order_list,@product_family)) }
      format.xml  { head :ok }
    end
  end
  
  private
  def load_order_list
    @order_list = OrderList.find(params[:order_list_id])
    @product_family = ProductFamily.find(params[:product_family_id])
  end
  
  def load_product_families_and_products
    @product_families = ProductFamily.find(:all, :order => "name ASC")
    @products = @product_family.products
  end
end
