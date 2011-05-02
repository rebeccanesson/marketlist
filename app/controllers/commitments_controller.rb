class CommitmentsController < ApplicationController
  before_filter :authenticate
  before_filter :owner_or_admin_user,  :except => [:show, :index, :new, :create]
  before_filter :admin_user_or_creator, :only => :create
  before_filter :load_order_list_and_listing
  before_filter :valid_timing, :only => [:create,:update,:destroy]
  
  # GET /commitments
  # GET /commitments.xml
  def index
    @commitments = Commitment.all
    @title = "Commitments"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commitments }
    end
  end

  # GET /commitments/1
  # GET /commitments/1.xml
  def show
    @commitment = Commitment.find(params[:id])
    @title = "Commitment for #{@commitment.orderable.product.name}"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commitment }
    end
  end

  # GET /commitments/new
  # GET /commitments/new.xml
  def new
    @commitment = Commitment.new
    @title = "New Commitment"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @commitment }
    end
  end

  # GET /commitments/1/edit
  def edit
    @title = "Edit Commitment"
  end

  # POST /commitments
  # POST /commitments.xml
  def create
    @commitment = Commitment.find(:first, :conditions => ["user_id = ? and orderable_id = ?", params[:commitment][:user_id], params[:commitment][:orderable_id]])
    if @commitment
      puts "found and existing commitment"
      @commitment.quantity += params[:commitment][:quantity].to_i
    else 
      @commitment = Commitment.new(params[:commitment])
    end
    res = @commitment.save
    respond_to do |format|
      if res
        @invoice = @commitment.invoice
        flash[:success] = 'Commitment was successfully created.'
        format.html { redirect_to(order_list_product_family_order_listing_commitment_path(@order_list,@product_family,@order_listing,@commitment)) }
        format.xml  { render :xml => @commitment, :status => :created, :location => @commitment }
        format.js
      else
        @title = "New Commitment"
        format.html { render 'new' }
        format.xml  { render :xml => @commitment.errors, :status => :unprocessable_entity }
        format.js   { render 'error' }
      end
    end
  end

  # PUT /commitments/1
  # PUT /commitments/1.xml
  def update

    respond_to do |format|
      if @commitment.update_attributes(params[:commitment])
        flash[:success] = 'Commitment was successfully updated.'
        format.html { redirect_to(order_list_product_family_order_listing_commitment_path(@order_list,@product_family,@order_listing,@commitment)) }
        format.xml  { head :ok }
      else
        @title = "Edit Commitment"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commitment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /commitments/1
  # DELETE /commitments/1.xml
  def destroy
    @commitment.destroy

    respond_to do |format|
      format.html { redirect_to home_path }
      # format.html { redirect_to(order_list_product_family_order_listing_commitments_url(@order_list,@product_family,@order_listing)) }
      format.xml  { head :ok }
    end
  end
  
  private
  def load_order_list_and_listing
    @order_listing = OrderListing.find(params[:order_listing_id])
    @order_list = OrderList.find(params[:order_list_id])
    @product_family = ProductFamily.find(params[:product_family_id])
  end
  
  def owner_or_admin_user
    @commitment = Commitment.find(params[:id])
    unless @commitment and current_user == @commitment.user
      admin_user
    end
  end
  
  def admin_user_or_creator
    unless current_user.id.to_s == params[:commitment][:user_id].to_s
      puts "they are not equal so checking if it is an admin"
      admin_user
    end
  end
  
  def valid_timing
    unless @order_list.order_start <= Time.now and Time.now <= @order_list.order_end
      admin_user
    end
  end
end
