class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :show]
  before_filter :correct_user, :only => [:edit, :update, :show]
  before_filter :admin_user,   :only => [:index, :destroy]
  
  def new
    @user = User.new
    @title = "Sign Up"
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :order => :name)
  end
  
  def show
    @user = User.find(params[:id])
    @title = "#{@user.name}"
  end
  
  def create
    @user = User.new(params[:user])
    if params[:user][:admin] and !admin?
      flash[:error] = "Only admins can create admins"
      @title = "Sign up"
      render 'new'
    elsif @user.save
      sign_in @user
      flash[:success] = "Welcome to the Market List!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if params[:user][:admin] and !admin?
      flash[:error] = "Only admins can create admins"
      @title = "Edit user"
      render 'edit'
    elsif @user.update_attributes(params[:user])
      flash[:success] = "Account updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def forgot_password 
    user = User.find_by_email(params[:email]) 
    if (user) 
      user.reset_password_code_until = 1.day.from_now 
      user.reset_password_code = Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" ) 
      user.save! UserNotifier.forgot_password(user).deliver 
      flash[:success] = "Reset password link emailed to #{user.email}"
      redirect_to '/'
    else 
      flash[:error] = "User not found for address #{params[:email]}"
      redirect_to '/'
    end
  end
  
  def reset_password 
    @user = User.find_by_reset_password_code(params[:reset_code]) 
    sign_in(@user) if @user && @user.reset_password_code_until && Time.now < @user.reset_password_code_until 
    if (current_user)
      render 'edit'
    else 
      flash[:error] = "Password reset code is no longer valid."
      redirect_to sign_in_path
    end
  end
  
  private

end
