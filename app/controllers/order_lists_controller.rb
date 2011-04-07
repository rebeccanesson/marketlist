class OrderListsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  
  # GET /order_lists
  # GET /order_lists.xml
  def index
    @active_order_lists = OrderList.active
    @inactive_order_lists = OrderList.inactive.paginate(:page => params[:page], :order => "order_start DESC")
    @title = "All Order Lists"
  end

  # GET /order_lists/1
  # GET /order_lists/1.xml
  def show
    @title = "Order List"
    @order_list = OrderList.find(params[:id])
  end

  # GET /order_lists/new
  # GET /order_lists/new.xml
  def new
    @market = Market.the_market
    @order_list = OrderList.new_for_market(@market)
    @order_list.user = current_user
    @title = "New Order List"
  end

  # GET /order_lists/1/edit
  def edit
    @title = "Edit Order List"
    @order_list = OrderList.find(params[:id])
    @product_families = ProductFamily.find(:all, :order => "name ASC")
  end

  # POST /order_lists
  # POST /order_lists.xml
  def create
    @order_list = OrderList.new(params[:order_list])
    @order_list.user = current_user
    
      if @order_list.save
        flash[:success] = 'Order list was successfully created.'
        redirect_to(edit_order_list_url(@order_list))
      else
        @title = "New Order List"
        render :action => "new" 
      end
  end

  # PUT /order_lists/1
  # PUT /order_lists/1.xml
  def update
    @order_list = OrderList.find(params[:id])
    @product_family = ProductFamily.find(params[:product_family_id]) if params[:product_family_id]

      if @order_list.update_attributes(params[:order_list])
        flash[:success] = 'Order list was successfully updated.'
        if @product_family
          redirect_to(order_list_product_family_order_listings_url(@order_list,@product_family))
        else 
          redirect_to edit_order_list_url(@order_list)
        end 
      else
        @product_families = ProductFamily.find(:all, :order => "name ASC")
        @title = "Edit Order List"
        render :action => "edit"
      end
  end

  # DELETE /order_lists/1
  # DELETE /order_lists/1.xml
  def destroy
    @order_list = OrderList.find(params[:id])
    @order_list.destroy

    redirect_to(order_lists_url)
  end
  
  def email
    @order_list = OrderList.find(params[:id])
    User.all.each do |u|
      UserNotifier.send_order_list(u, @order_list).deliver
    end
    flash[:success] = "Order list emailed to users"
    redirect_to(order_lists_url)
  end
  
  def email_invoices
    @order_list = OrderList.find(params[:id])
    User.all.each do |u|
      invoice = @order_list.invoice_for_user(u)
      if invoice 
        UserNotifier.send_invoice(u,invoice).deliver
      end
    end
    flash[:success] = "Invoices emailed to users"
    redirect_to(order_lists_url)
  end
  
  def redux_by_listing
    @order_list = OrderList.find(params[:id])
  end
  
  def redux_by_user
    @order_list = OrderList.find(params[:id])
  end
  
  def redux_unclaimed
    @order_list = OrderList.find(params[:id])
  end
  
  def duplicate
    @old_order_list = OrderList.find(params[:id])
    @order_list = @old_order_list.duplicate_for_market(Market.the_market)
    flash[:success] = 'Duplicated order list'
    redirect_to order_list_path(@order_list)
  end
  
end
