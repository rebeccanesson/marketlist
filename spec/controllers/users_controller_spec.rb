require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do 
    User.all.each { |u| u.destroy }
  end
  
  describe "GET 'index'" do

     describe "for non-signed-in users" do
       it "should deny access" do
         get :index
         response.should redirect_to(signin_path)
         flash[:notice].should =~ /sign in/i
       end
     end
       
    describe "for signed in non-admin users" do 
         it "should deny access" do 
           @user = test_sign_in(Factory(:user))
           get :index
           response.should redirect_to(root_path)
         end
    end
       
     describe "for admin users" do

       before(:each) do
         @user = Factory(:user)
         @user.toggle!(:admin)
         @user = test_sign_in(@user)
         second = Factory(:user, :name => "Bob", :email => "another@example.com")
         third  = Factory(:user, :name => "Ben", :email => "another@example.net")

         @users = [@user, second, third]
         30.times do |i|
           @users << Factory(:user, :email => "another#{i}@example.org")
         end
       end

       it "should be successful" do
         get :index
         response.should be_success
       end

       it "should have the right title" do
         get :index
         response.should have_selector("title", :content => "All users")
       end

       it "should have an element for each user" do
         get :index
         @users[0..2].each do |user|
           response.should have_selector("li", :content => user.name)
         end
       end
      
       it "should paginate users" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector("a", :href => "/users?page=2",
                                             :content => "2")
          response.should have_selector("a", :href => "/users?page=2",
                                             :content => "Next")
       end
       
     end
   end
  

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign Up")
    end 

  end
  
  describe "GET 'show'" do
    describe "for admin users" do
      before(:each) do
        @user = Factory(:user)
        @admin_user = Factory(:user, :name => "Admin User", :email => "admin@admin.org", :admin => true)
        @admin_user = test_sign_in(@admin_user)
      end

      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end
     
      it "should have the right title" do
        get :show, :id => @user
        response.should have_selector("title", :content => @user.name)
      end

      it "should include the user's name" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.name)
      end

      it "should have a profile image" do
        get :show, :id => @user
        response.should have_selector("h1>img", :class => 'gravatar')
      end
    end
    
    describe "for the user herself" do 
      it "should be successful" do
        @user = Factory(:user)
        @user = test_sign_in(@user)
        get :show, :id => @user
        response.should be_success
      end
    end
    
    describe "for signed in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @signed_in_user = Factory(:user, :name => "Other User", :email => "theother@guy.com")
        @signed_in_user = test_sign_in(@signed_in_user)
        get :show, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        get :show, :id => @user
        response.should redirect_to(signin_path)
      end
    end
     
  end
  
  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end  
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the market list/i
      end  
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
    end
    
  end
  
  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of create/edit/update pages" do

    before(:each) do
      @user = Factory(:user)
      @attr = { :name => "New User", :email => "user@example.com",
                :password => "foobar", :password_confirmation => "foobar", :admin => true }
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do

      before(:each) do
        @wrong_user = Factory(:user, :email => "user@example.net")
        @wrong_user = test_sign_in(@wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
      
      it "should require admin users for 'update' including admin" do 
        put :update, :id => @wrong_user, :user => {:admin => true}
        response.should render_template('edit')
      end
      
      it "should require admin users to create admin users" do 
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "for admin users" do 
      before(:each) do 
        @admin_user = Factory(:user, :email => "admin@admin.foo")
        @admin_user.toggle!(:admin)
        @admin_user = test_sign_in(@admin_user)
      end
      
      it "should allow update of admin attribute" do 
        put :update, :id => @user, :user => {:admin => true}
        assigns(:user).admin.should == true
      end
      
      it "should allow admin to create an admin user" do 
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
    end
    
  end
  
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
  

end