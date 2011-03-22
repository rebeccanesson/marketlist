require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe OrderListsController do
  render_views
  
  before(:each) do 
    User.all.each { |u| u.destroy }
  end

  describe "GET index" do
    
    describe "as a non-admin user" do
       before(:each) do
         @user = Factory(:user)
       end

       it "should protect the page" do
         test_sign_in(@user)
         get 'index'
         response.should redirect_to(root_path)
       end
    end
    
    describe "as a non-logged in user" do 
      it "should protect the page" do 
        get 'index'
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as an admin user" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @user = test_sign_in(@user)
        first = Factory(:order_list, :user => @user)
        second = Factory(:order_list, :user => @user)
        third  = Factory(:order_list, :user => @user)
        @order_lists = [first, second, third]
        30.times do
          @order_lists << Factory(:order_list, :user => @user)
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All Order Lists")
      end
      
      it "should have an element for each order list" do
        get :index
        @order_lists[0..2].each do |ol|
          response.should have_selector("li", :content => "Delivery period")
        end
      end
      
      it "should paginate order_lists" do
         get :index
         response.should have_selector("div.pagination")
         response.should have_selector("span.disabled", :content => "Previous")
         response.should have_selector("a", :href => "/order_lists?page=2",
                                            :content => "2")
         response.should have_selector("a", :href => "/order_lists?page=2",
                                            :content => "Next")
      end
      
    end

  end
  
  describe "GET 'new'" do
    describe "for admin users" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @user = test_sign_in(@user)
      end
      
      it "should be successful" do
        get 'new'
        response.should be_success
      end
  
      it "should have the right title" do
        get 'new'
        response.should have_selector("title", :content => "New Order List")
      end 
      
      it "should have a non-nil market available" do 
        get 'new'
        assigns(:market).should == Market.the_market
      end
    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        get 'new'
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for non-admin users" do 
      before(:each) do 
        @user = Factory(:user)
        @user = test_sign_in(@user)
      end
      
      it "should protect the page" do 
        get 'new'
        response.should redirect_to(root_path)
      end
    end

  end
  
  describe "GET 'show'" do
    describe "for logged in users" do
      before(:each) do
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
      end

      it "should be successful" do
        get :show, :id => @order_list
        response.should be_success
      end

      it "should find the right order_list" do
        get :show, :id => @order_list
        assigns(:order_list).should == @order_list
      end
     
      it "should have the right title" do
        get :show, :id => @order_list
        response.should have_selector("title", :content => "Order List")
      end

    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
        get :show, :id => @order_list
        response.should redirect_to(signin_path)
      end
    end
     
  end
  
  describe "POST 'create'" do
    
    describe "for admin users" do 

      describe "failure" do

        before(:each) do
          @user = Factory(:user)
          @user.toggle!(:admin)
          @user = test_sign_in(@user)
          @attr = { :order_start => Time.zone.now - 2.days, :order_end => nil, 
                    :delivery_start => nil, :delivery_end => nil, :user => nil }
        end

        it "should not create an order list" do
          lambda do
            post :create, :order_list => @attr
          end.should_not change(OrderList, :count)
        end

        it "should have the right title" do
          post :create, :order_list => @attr
          response.should have_selector("title", :content => "New Order List")
        end

        it "should render the 'new' page" do
          post :create, :order_list => @attr
          response.should render_template('new')
        end
      end
    
      describe "success" do

        before(:each) do
          @user = Factory(:user)
          @user.toggle!(:admin)
          @user = test_sign_in(@user)
          @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                    :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 6.hours, 
                    :user => @user }
        end

        it "should create an order list" do
          lambda do
            post :create, :order_list => @attr
          end.should change(OrderList, :count).by(1)
        end

        it "should redirect to the order list show page" do
          post :create, :order_list => @attr
          response.should redirect_to(order_lists_path)
        end  
     end
    end
    
    describe "for non-admin users" do 
      
      before(:each) do 
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                  :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 6.hours, 
                  :user => @user }
      end
      
      it "should protect the page" do 
        post :create, :order_list => @attr
        response.should redirect_to(root_path)
      end
   end
   
   describe "for non-logged in users" do 
     before(:each) do 
       @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                 :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 6.hours, 
                 :user => @user }
     end
      
      it "should protect the page" do 
        post :create, :order_list => @attr
        response.should redirect_to(signin_path)
      end
    
   end
    
  end
  
  describe "GET 'edit'" do

    describe "for admin users" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
      end

      it "should be successful" do
        get :edit, :id => @order_list
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @order_list
        response.should have_selector("title", :content => "Edit Order List")
      end
      
      it "should set the product families" do 
        get :edit, :id => @order_list
        assigns(:product_families).should_not be_nil
      end
    end 
    
    describe "for logged in users" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
      end
      
      it "should protect the page" do 
        get :edit, :id => @order_list
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged in users" do 
      before(:each) do
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
      end
      
      it "should protect the page" do 
        get :edit, :id => @order_list
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "PUT 'update'" do

    describe "for admin users" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        test_sign_in(@user)
      end

      describe "failure" do

        before(:each) do
          @attr = { :order_start => nil, :order_end => nil, :delivery_start => nil, :delivery_end => nil, 
                    :user => nil }
          @order_list = Factory(:order_list, :user => @user)
        end

        it "should render the 'edit' page" do
          put :update, :id => @order_list, :order_list => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @order_list, :order_list => @attr
          response.should have_selector("title", :content => "Edit Order List")
        end

      end

      describe "success" do

        before(:each) do
          @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                    :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 7.hours, 
                    :user => @user }
          @order_list = Factory(:order_list, :user => @user)
        end

        it "should change the order list's attributes" do
          put :update, :id => @order_list, :order_list => @attr
          @order_list.reload
          @order_list.order_start.should  == @attr[:order_start]
          @order_list.order_end.should == @attr[:order_end]
          @order_list.delivery_start.should == @attr[:delivery_start]
          @order_list.delivery_end.should == @attr[:delivery_end]
          @order_list.user.should == @attr[:user]
        end

        it "should redirect to the order_list show page" do
          put :update, :id => @order_list, :order_list => @attr
          response.should redirect_to(order_lists_path)
        end

        it "should have a flash message" do
          put :update, :id => @order_list, :order_list => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
    
    describe "for non-admin users" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
        @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                  :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 4.hours, 
                  :user => @user }
      end
      
      it "should protect the page" do 
        put :update, :id => @order_list, :order_list => @attr
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged in users" do 
      before(:each) do
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
        @attr = { :order_start => Time.zone.now + 2.days, :order_end => Time.zone.now + 4.days, 
                  :delivery_start => Time.zone.now + 6.days, :delivery_end => Time.zone.now + 6.days + 4.hours, 
                  :user => @user }     
      end
      
      it "should protect the page" do 
        put :update, :id => @order_list, :order_list => @attr
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      @order_list = Factory(:order_list, :user => @user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @order_list
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @order_list
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the order list" do
        lambda do
          delete :destroy, :id => @order_list
        end.should change(OrderList, :count).by(-1)
      end

      it "should redirect to the order list page" do
        delete :destroy, :id => @order_list
        response.should redirect_to(order_lists_path)
      end
    end
  end

end
