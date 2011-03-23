class UserFamilyBlocksController < ApplicationController
  before_filter :load_user
  
  def index
    @product_families = ProductFamily.find(:all, :order => "upper(name) ASC")
  end
  
  def batch_create
    if params[:product_family_locks] and !admin?
      flash[:error] = "Only admins can lock product families for users"
      redirect_to 'index'
    end
    @user.batch_create_blocks(params[:product_family],params[:product_family_locks])
    redirect_to user_user_family_blocks_path(@user)
  end
  
  private
  def load_user
    @user = User.find(params[:user_id])
  end
  
end
