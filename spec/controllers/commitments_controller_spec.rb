require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe CommitmentsController do
  render_views
  
  before(:each) do 
    User.all.each { |u| u.destroy }
  end

  describe "GET index" do
    
    describe "as a non-admin user" do
       before(:each) do
         @user = Factory(:user)
         @user = test_sign_in(@user)
         @order_list = Factory(:order_list, :user => @user)
         @product_family = Factory(:product_family, :name => "Tomatoes")
         @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
       end

       it "should be successful" do
         get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         response.should be_success
       end

       it "should have the right title" do
         get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         response.should have_selector("title", :content => "Commitments")
       end
    end
    
    describe "as a non-logged in user" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        get 'index', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as an admin user" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @user = test_sign_in(@user)
        @seller = Factory(:user, :email => Faker::Internet.email)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        first_o = Factory(:orderable, :order_listing => @order_listing)
        first = Factory(:commitment, :orderable => first_o, :user => @seller)
        second_o = Factory(:orderable, :order_listing => @order_listing)
        second = Factory(:commitment, :orderable => second_o, :user => @seller)
        third_o  = Factory(:orderable, :order_listing => @order_listing)
        third = Factory(:commitment, :orderable => third_o, :user => @seller)
        @commitments = [first, second, third]
        30.times do
          ord = Factory(:orderable, :order_listing => @order_listing)
          @commitments << Factory(:commitment, :orderable => ord, :user => @seller)
        end
      end

      it "should be successful" do
        get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end

      it "should have the right title" do
        get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "Commitments")
      end
      
    end

  end
  
  describe "GET 'new'" do
    describe "for admin users" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @user = test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
      end
      
      it "should be successful" do
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
  
      it "should have the right title" do
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "New Commitment")
      end 
    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for non-admin users" do 
      before(:each) do 
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
      end
      
      it "should be successful" do
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
  
      it "should have the right title" do
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "New Commitment")
      end
    end
  
  end
  
  describe "GET 'show'" do
    describe "for logged in users" do
      before(:each) do
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @seller = Factory(:user, :email => Faker::Internet.email)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller)
      end
    
      it "should be successful" do
        get :show, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
          
      it "should find the right commitment" do
        get :show, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        assigns(:commitment).should == @commitment
      end
           
      it "should have the right title" do
        get :show, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => @commitment.orderable.product.name)
      end
          
      it "should include the commitment's orderable's product's name" do
        get :show, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("h2", :content => @commitment.orderable.product.name)
      end
    
    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @seller = Factory(:user, :email => Faker::Internet.email)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller)
        get :show, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
          @order_list = Factory(:order_list, :user => @user)
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @attr = { :orderable => nil, :user => nil, :quantity => nil}
        end
  
        it "should not create a commitment" do
          lambda do
            post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          end.should_not change(Commitment, :count)
        end
  
        it "should have the right title" do
          post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should have_selector("title", :content => "Home")
        end
  
        it "should render the 'new' page" do
          post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should render_template('pages/home')
        end
      end
    
      describe "success" do
  
        before(:each) do
          @user = Factory(:user)
          @user.toggle!(:admin)
          @user = test_sign_in(@user)
          @seller = Factory(:user, :email => Faker::Internet.email)
          @order_list = Factory(:order_list, :user => @user)
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 5)
          @product = Factory(:product, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @attr = { :orderable => @orderable, :user => @seller, :quantity => 2}
        end
  
        it "should create a commitment" do
          lambda do
            post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          end.should change(Commitment, :count).by(1)
        end
        
        it "should fail to create a commitment if there is not enough quantity in the order listing" do 
          lambda do 
            post :create, :commitment => @attr.merge(:quantity => 10), :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          end.should_not change(Commitment, :count)
        end
        
        it "should redirect to the commitment show page" do
          post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should redirect_to(home_path)
        end  
     end
    end
    
    describe "for non-admin users other than the seller" do 
      
      before(:each) do 
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @seller = Factory(:user, :email => "seller5@farm.org")
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 3)
        @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
        @attr = { :orderable => @orderable, :user => @seller, :quantity => 2 }
      end
      
      it "should protect the page" do 
        post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(root_path)
      end
   end
   
   describe "for non-logged in users" do 
     before(:each) do 
       @user = Factory(:user)
       @order_list = Factory(:order_list, :user => @user)
       @product_family = Factory(:product_family, :name => "Tomatoes")
       @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
       @product = Factory(:product, :product_family => @product_family)
       @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
       @attr = { :orderable => @orderable, :user => @seller, :quantity => 2}
      end
      
      it "should protect the page" do 
        post :create, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    
   end
    
  end
  
  describe "GET 'edit'" do
  
    describe "for admin users" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @seller = Factory(:user, :email => "seller4@farm.org")
        test_sign_in(@user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 3)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller, :quantity => 2)
      end
  
      it "should be successful" do
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
  
      it "should have the right title" do
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "Edit Commitment")
      end
    end 
    
    describe "for logged in users that are the seller" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @seller = Factory(:user, :email => "seller3@farm.org")
        test_sign_in(@seller)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 3)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller, :quantity => 2)
      end
  
      it "should be successful" do
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
  
      it "should have the right title" do
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "Edit Commitment")
      end
    end
    
    describe "for logged in users that aren't the committer" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @seller = Factory(:user, :email => "seller7@farm.org")
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller)
      end
      
      it "should protect the page" do 
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged in users" do 
      before(:each) do
        @user = Factory(:user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @user)
      end
      
      it "should protect the page" do 
        get :edit, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
        @seller = Factory(:user, :email => "seller2@farm.org")
      end
  
      describe "failure" do
  
        before(:each) do
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller)
          @attr = { :orderable => nil, :user => nil, :quantity => nil }
        end
  
        it "should render the 'edit' page" do
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should render_template('edit')
        end
  
        it "should have the right title" do
          put :update, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :commitment => @attr, :product_family_id => @product_family.id
          response.should have_selector("title", :content => "Edit Commitment")
        end
  
      end
  
      describe "success" do
  
        before(:each) do
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 5)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @commitment = Factory(:commitment, :user => @seller, :orderable => @orderable, :quantity => 2)
          @attr = {:orderable => @orderable, :user => @seller, :quantity => 1}
        end
  
        it "should change the commitments's attributes" do
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          @commitment.reload
          @commitment.orderable.should  == @attr[:orderable]
          @commitment.user.should == @attr[:user]
          @commitment.quantity.should == @attr[:quantity]
        end
  
        it "should redirect to the commitment show page" do
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should redirect_to(order_list_product_family_order_listing_commitment_path(@order_list,@product_family, @order_listing, @commitment))
        end
  
        it "should have a flash message" do
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          flash[:success].should =~ /updated/
        end
      end
    end
    
    describe "for logged in users who are the seller" do 
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        @seller = Factory(:user, :email => "seller1@farm.org")
        test_sign_in(@seller)
      end
  
      describe "failure" do
  
        before(:each) do
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_list.order_start = Time.now - 1.day
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller)
          @attr = { :orderable => nil, :user => nil, :quantity => nil }
        end
  
        it "should render the 'edit' page" do
          @now = Time.now
          Time.stub!(:now).and_return(@now + 3.days)
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should render_template('edit')
        end
  
        it "should have the right title" do
          @now = Time.now
          Time.stub!(:now).and_return(@now + 3.days)
          put :update, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :commitment => @attr, :product_family_id => @product_family.id
          response.should have_selector("title", :content => "Edit Commitment")
        end
  
      end
  
      describe "success" do
  
        before(:each) do
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 5)
          @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
          @commitment = Factory(:commitment, :user => @seller, :orderable => @orderable, :quantity => 2)
          @attr = {:orderable => @orderable, :user => @seller, :quantity => 1}
        end
  
        it "should change the commitments's attributes" do
          @now = Time.now
          Time.stub!(:now).and_return(@now + 3.days)
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          @commitment.reload
          @commitment.orderable.should  == @attr[:orderable]
          @commitment.user.should == @attr[:user]
          @commitment.quantity.should == @attr[:quantity]
        end
  
        it "should redirect to the commitment show page" do
          @now = Time.now
          Time.stub!(:now).and_return(@now + 3.days)
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should redirect_to(order_list_product_family_order_listing_commitment_path(@order_list,@product_family, @order_listing, @commitment))
        end
  
        it "should have a flash message" do
          @now = Time.now
          Time.stub!(:now).and_return(@now + 3.days)
          put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          flash[:success].should =~ /updated/
        end
      end
    end
    
    describe "for non-admin users who are also not the committer" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @seller = Factory(:user, :email => "seller@farm.org")
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 5)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller, :quantity => 1)
        @attr = { :orderable => @orderable, :user => @seller, :quantity => 2 }     
      end
      
      it "should protect the page" do 
        put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged in users" do 
      before(:each) do
        @user = Factory(:user)
        @seller = Factory(:user, :email => "seller6@farm.org")
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
        @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller, :quantity => 1)
        @attr = { :orderable => @orderable, :user => @seller, :quantity => 2 }     
      end
      
      it "should protect the page" do 
        put :update, :id => @commitment, :commitment => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "DELETE 'destroy'" do
  
    before(:each) do
      @user = Factory(:user)
      @seller = Factory(:user, :email => Faker::Internet.email)
      @product_family = Factory(:product_family, :name => "Tomatoes")
      @product = Factory(:product, :product_family => @product_family)
      @order_list = Factory(:order_list, :user => @user)
      @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 5)
      @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
      @commitment = Factory(:commitment, :orderable => @orderable, :user => @seller, :quantity => 1)
    end
  
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
  
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(root_path)
      end
    end
    
    describe "as the committer user" do

       before(:each) do
         test_sign_in(@seller)
       end

       it "should destroy the commitment" do
         @now = Time.now
         Time.stub!(:now).and_return(@now + 3.days)
         lambda do
           delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         end.should change(Commitment, :count).by(-1)
       end
       
      it "should not destroy the commitment after ordering closes" do 
        @order_list.order_end = Time.now - 1.hour
        lambda do
          delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        end.should_not change(Commitment, :count)
      end 
          

       it "should redirect to the commitment page" do
         @now = Time.now
         Time.stub!(:now).and_return(@now + 3.days)
         delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         response.should redirect_to(home_path)
       end
     end
  
    describe "as an admin user" do
  
      before(:each) do
        admin = Factory(:user, :email => "admin1@example.com", :admin => true)
        test_sign_in(admin)
      end
  
      it "should destroy the commitment" do
        lambda do
          delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        end.should change(Commitment, :count).by(-1)
      end
  
      it "should redirect to the commitment page" do
        delete :destroy, :id => @commitment, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(home_path)
      end
    end
  end
end