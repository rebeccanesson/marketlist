class UserFamilyBlocksController < ApplicationController
  
  def index
    @product_families = ProductFamily.find(:all, :order => "upper(name) ASC")
  end
  
end
