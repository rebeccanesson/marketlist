class PagesController < ApplicationController
  before_filter :authenticate, :only => :admin
  before_filter :admin_user,   :only => :admin

  def contact
    @title = "Contact"
    @market = Market.the_market
  end
  
  def about
    @title = "About"
  end
  
  def admin
    @title = "Site Management"
    @market = Market.the_market
  end
  
  def home
    @title = "Home"
    @open_order_lists = OrderList.find(:all, :conditions => ["order_start <= ? and order_end >= ?", Time.now, Time.now])
    @upcoming_order_list = OrderList.find(:first, :conditions => ["order_start > ?", Time.now], :order => "order_start ASC")
  end
  
  private
  def authenticate
    deny_access unless signed_in?
  end

end
