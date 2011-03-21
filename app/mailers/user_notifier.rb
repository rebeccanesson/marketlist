class UserNotifier < ActionMailer::Base
  default :from => Market.the_market.contact_email
  default :subject => Market.the_market.name
  
  def forgot_password(user)
      @user = user
      @url  = "http://marketlist.heroku.com/users/reset_password?reset_code=#{user.reset_password_code}"
      mail(:to => "#{user.name} <#{user.email}>", :subject => "#{Market.the_market.name} - Password Reset")
  end
  
  def send_invoice(user,invoice)
    @invoice = invoice
    @user = user
    @market = Market.the_market
    mail(:to => "#{user.name} <#{user.email}>", :subject => "#{Market.the_market.name} - Invoice for Delivery on #{invoice.order_list.order_start.strftime('%x')}")
  end
  
  def send_order_list(user,order_list)
    @user = user
    @order_list = order_list
    mail(:to => "#{user.name} <#{user.email}>", :subject => "#{Market.the_market.name} - Ordering Open")
  end
  
end
