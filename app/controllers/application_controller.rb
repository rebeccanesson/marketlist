class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :load_market
  
  def authenticate
    deny_access unless signed_in?
  end 
  
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user) or current_user.admin?
      flash[:error] = "You are not authorized to perform that action"
      redirect_to(root_path) 
    end
  end
  
  def admin_user
    unless current_user.admin?
      flash[:error] = "Only site administrators may perform that action"
      redirect_to(root_path)
    end 
  end
  
  def load_market
    @market = Market.the_market
  end
  
end
