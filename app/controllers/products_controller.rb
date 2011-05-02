class ProductsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  
  # GET /products
  # GET /products.xml
  def index
    @products = Product.paginate(:page => params[:page], :include => :product_family, :order => "upper(product_families.name) ASC, products.name ASC")
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
    @product.product_family = ProductFamily.find(params[:product_family_id]) if params[:product_family_id]
    @title = "New Product"
    @product_families = ProductFamily.find(:all, :order => "name ASC")
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @title = "Edit Product"
    @product_families = ProductFamily.find(:all, :order => "name ASC")
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
      if @product.save
        flash[:success] = 'Product was successfully created.'
        redirect_to(@product)
      else
        @product_families = ProductFamily.find(:all, :order => "name ASC")
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
        @product_families = ProductFamily.find(:all, :order => "name ASC")
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
  
  def create_from_csv
    res = Product.create_from_csv(params[:upload])
    msg = ""
    msg += "Created or updated #{res[0].join(', ')}. " unless res[0].empty?
    msg += "Could not create or update #{res[1].join(', ')}." unless res[1].empty?
    flash[:success] = msg
    @products = Product.paginate(:page => params[:page], :include => :product_family, :order => "upper(product_families.name) ASC, products.name ASC")
    @title = "All Products"
    redirect_to products_url
  end
  
  private
  
end
