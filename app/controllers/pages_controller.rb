class PagesController < ApplicationController
  before_filter :authenticate, :only => :admin
  before_filter :admin_user,   :only => :admin

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def admin
    @title = "Site Management"
  end
  
  private
  def authenticate
    deny_access unless signed_in?
  end

end
