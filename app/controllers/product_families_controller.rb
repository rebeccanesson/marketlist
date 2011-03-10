class ProductFamiliesController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user,  :except => :show
  
  # GET /product_families
  # GET /product_families.xml
  def index
    @product_families = ProductFamily.paginate(:page => params[:page], :order => "name ASC")
    @title = "All Product Families"
  end

  # GET /product_families/1
  # GET /product_families/1.xml
  def show
    @product_family = ProductFamily.find(params[:id])
    @title = "#{@product_family.name}"
  end

  # GET /product_families/new
  # GET /product_families/new.xml
  def new
    @product_family = ProductFamily.new
    @title = "New Product Family"
  end

  # GET /product_families/1/edit
  def edit
    @title = "Edit Product Family"
    @product_family = ProductFamily.find(params[:id])
  end

  # POST /product_families
  # POST /product_families.xml
  def create
    @product_family = ProductFamily.new(params[:product_family])
    
      if @product_family.save
        flash[:success] = 'Product family was successfully created.'
        redirect_to(product_families_path)
      else
        @title = "New Product Family"
        render :action => "new" 
      end
  end

  # PUT /product_families/1
  # PUT /product_families/1.xml
  def update
    @product_family = ProductFamily.find(params[:id])

      if @product_family.update_attributes(params[:product_family])
        flash[:success] = 'Product family was successfully updated.'
        redirect_to(product_families_path) 
      else
        @title = "Edit Product Family"
        render :action => "edit"
      end
  end

  # DELETE /product_families/1
  # DELETE /product_families/1.xml
  def destroy
    @product_family = ProductFamily.find(params[:id])
    if (@product_family.products.count > 0)
      flash[:error] = 'Product families cannot be deleted when they contain products.'
      redirect_to(product_family_url(@product_family))
    else 
      @product_family.destroy
      redirect_to(product_families_url)
    end
  end
  
end
