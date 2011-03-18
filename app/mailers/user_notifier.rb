class UserNotifier < ActionMailer::Base
  default :from => Market.the_market.contact_email
  default :subject => Market.the_market.name
  
  def forgot_password(user)
      @user = user
      @url  = "http://marketlist.heroku.com/users/reset_password?reset_code=#{user.reset_password_code}"
      mail(:to => "#{user.name} <#{user.email}>")
  end
  
end
