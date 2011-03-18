class UserNotifier < ActionMailer::Base
  default :from => Market.the_market.contact_email
  default :subject => Market.the_market.name
  
  def forgot_password(user)
      mail(:to => "#{user.name} <#{user.email}>")
      @subject     = "#{Market.the_market.name} - Reset Password"  
      @url  = "http://marketlist.heroku.com/users/reset_password/#{user.reset_password_code}"
  end
  
end
