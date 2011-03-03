class ProductsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  
  # GET /products
  # GET /products.xml
  def index
    @products = Product.paginate(:page => params[:page], :order => "name ASC")
    @title = "All Products"
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @title = @product.name
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    @title = "New Product"
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @title = "Edit Product"
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
      if @product.save
        flash[:success] = 'Product was successfully created.'
        redirect_to(@product)
      else
        @title = "New Product"
        render "new" 
      end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])
      if @product.update_attributes(params[:product])
        flash[:success] = 'Product was successfully updated.'
        redirect_to(@product)
      else
        @title = "Edit Product"
        render "edit" 
      end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to(products_url) 
  end
  
  private
  
end
