class OrderListsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  
  # GET /order_lists
  # GET /order_lists.xml
  def index
    @order_lists = OrderList.paginate(:page => params[:page], :order => "order_start DESC")
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
    @order_list = OrderList.new
    @order_list.user = current_user
    @title = "New Order List"
  end

  # GET /order_lists/1/edit
  def edit
    @title = "Edit Order List"
    @order_list = OrderList.find(params[:id])
  end

  # POST /order_lists
  # POST /order_lists.xml
  def create
    @order_list = OrderList.new(params[:order_list])
    @order_list.user = current_user
    
      if @order_list.save
        flash[:success] = 'Order list was successfully created.'
        redirect_to(@order_list)
      else
        @title = "New Order List"
        render :action => "new" 
      end
  end

  # PUT /order_lists/1
  # PUT /order_lists/1.xml
  def update
    @order_list = OrderList.find(params[:id])

      if @order_list.update_attributes(params[:order_list])
        flash[:success] = 'Order list was successfully updated.'
        redirect_to(@order_list) 
      else
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
  
end
