require 'spec_helper'

describe OrderablesController do
  render_views
  
  before(:each) do 
    User.all.each { |u| u.destroy }
  end

  describe "GET index" do
    
    describe "as a non-admin user" do
       before(:each) do
         @user = Factory(:user)
         @order_list = Factory(:order_list, :user => @user)
         @product_family = Factory(:product_family, :name => "Tomatoes")
         @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
       end

       it "should protect the page" do
         test_sign_in(@user)
         get 'index', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         response.should redirect_to(root_path)
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
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        first = Factory(:orderable, :order_listing => @order_listing)
        second = Factory(:orderable, :order_listing => @order_listing)
        third  = Factory(:orderable, :order_listing => @order_listing)
        @orderables = [first, second, third]
        30.times do
          @orderables << Factory(:orderable, :order_listing => @order_listing)
        end
      end

      it "should be successful" do
        get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end

      it "should have the right title" do
        get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "Orderables")
      end

      it "should have an element for each orderable" do
        get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        @orderables[0..2].each do |ord|
          response.should have_selector("td", :content => ord.product.name)
        end
      end
      
      it "should paginate orderables" do
         get :index, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
         response.should have_selector("div.pagination")
         response.should have_selector("span.disabled", :content => "Previous")
         response.should have_selector("a", :href => "/order_lists/#{@order_list.id}/product_families/#{@product_family.id}/order_listings/#{@order_listing.id}/orderables?page=2",
                                            :content => "2")
         response.should have_selector("a", :href => "/order_lists/#{@order_list.id}/product_families/#{@product_family.id}/order_listings/#{@order_listing.id}/orderables?page=2",
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
        response.should have_selector("title", :content => "New Orderable")
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
      
      it "should protect the page" do 
        get 'new', :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
      end
    
      it "should be successful" do
        get :show, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
          
      it "should find the right orderable" do
        get :show, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        assigns(:orderable).should == @orderable
      end
           
      it "should have the right title" do
        get :show, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => @orderable.product.name)
      end
          
      it "should include the orderable's product's name" do
        get :show, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("h2", :content => @orderable.product.name)
      end
    
    end
    
    describe "for non-logged in users" do 
      it "should protect the page" do 
        @user = Factory(:user)
        @order_list = Factory(:order_list, :user => @user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
        get :show, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @attr = { :organic_price => nil, :conventional_price => nil, :product => nil, :order_listing_id => nil}
        end
  
        it "should not create a product" do
          lambda do
            post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          end.should_not change(Orderable, :count)
        end
  
        it "should have the right title" do
          post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should have_selector("title", :content => "New Orderable")
        end
  
        it "should render the 'new' page" do
          post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should render_template('new')
        end
      end
    
      describe "success" do
  
        before(:each) do
          @user = Factory(:user)
          @user.toggle!(:admin)
          @user = test_sign_in(@user)
          @order_list = Factory(:order_list, :user => @user)
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @product = Factory(:product, :product_family => @product_family)
          @attr = { :order_listing => @order_listing, :product => @product, :organic_price => 10.00, :conventional_price => 7.00}
        end
  
        it "should create an orderable" do
          lambda do
            post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          end.should change(Orderable, :count).by(1)
        end
  
        it "should redirect to the orderable show page" do
          post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should redirect_to(order_list_product_family_order_listing_orderable_path(@order_list,@product_family,@order_listing,assigns(:orderable)))
        end  
     end
    end
    
    describe "for non-admin users" do 
      
      before(:each) do 
        @user = Factory(:user)
        @user = test_sign_in(@user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
       @attr = { :product => @product, :order_listing => @order_listing, :organic_price => 10.00, :conventional_price => 7.00 }
      end
      
      it "should protect the page" do 
        post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
       @attr = { :product => @product, :order_listing => @order_listing, :organic_price => 10.00, :conventional_price => 7.00 }
      end
      
      it "should protect the page" do 
        post :create, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
      end
  
      it "should be successful" do
        get :edit, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should be_success
      end
  
      it "should have the right title" do
        get :edit, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should have_selector("title", :content => "Edit Orderable")
      end
    end 
    
    describe "for logged in users" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :product => @product, :order_listing => @order_listing)
      end
      
      it "should protect the page" do 
        get :edit, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
      end
      
      it "should protect the page" do 
        get :edit, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing)
          @attr = {:product => @product, :order_listing => @order_listing, :organic_price => nil, :conventional_price => nil}
        end
  
        it "should render the 'edit' page" do
          put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should render_template('edit')
        end
  
        it "should have the right title" do
          put :update, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :orderable => @attr, :product_family_id => @product_family.id
          response.should have_selector("title", :content => "Edit Orderable")
        end
  
      end
  
      describe "success" do
  
        before(:each) do
          @product_family = Factory(:product_family, :name => "Tomatoes")
          @product = Factory(:product, :product_family => @product_family)
          @order_list = Factory(:order_list, :user => @user)
          @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
          @orderable = Factory(:orderable, :order_listing => @order_listing)
          @attr = {:product => @product, :order_listing => @order_listing, :organic_price => 5.00, :conventional_price => 4.00}
        end
  
        it "should change the orderable's attributes" do
          put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          @orderable.reload
          @orderable.product.should  == @attr[:product]
          @orderable.order_listing.should == @attr[:order_listing]
          @orderable.organic_price.should == @attr[:organic_price]
          @orderable.conventional_price.should == @attr[:conventional_price]
        end
  
        it "should redirect to the orderable show page" do
          put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          response.should redirect_to(order_list_product_family_order_listing_orderable_path(@order_list,@product_family, @order_listing, @orderable))
        end
  
        it "should have a flash message" do
          put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
          flash[:success].should =~ /updated/
        end
      end
    end
    
    describe "for non-admin users" do 
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @product_family = Factory(:product_family, :name => "Tomatoes")
        @product = Factory(:product, :product_family => @product_family)
        @order_list = Factory(:order_list, :user => @user)
        @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
        @orderable = Factory(:orderable, :order_listing => @order_listing)
         @attr = { :product => @product, :order_listing => @order_listing, :organic_price => 5.00, :conventional_price => 4.00 }     
      end
      
      it "should protect the page" do 
        put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
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
        @orderable = Factory(:orderable, :order_listing => @order_listing)
         @attr = { :product => @product, :order_listing => @order_listing, :organic_price => 5.00, :conventional_price => 4.00 }     
      end
      
      it "should protect the page" do 
        put :update, :id => @orderable, :orderable => @attr, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "DELETE 'destroy'" do
  
    before(:each) do
      @user = Factory(:user)
      @product_family = Factory(:product_family, :name => "Tomatoes")
      @product = Factory(:product, :product_family => @product_family)
      @order_list = Factory(:order_list, :user => @user)
      @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family)
      @orderable = Factory(:orderable, :order_listing => @order_listing)
    end
  
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(signin_path)
      end
    end
  
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(root_path)
      end
    end
  
    describe "as an admin user" do
  
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
  
      it "should destroy the product" do
        lambda do
          delete :destroy, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        end.should change(Orderable, :count).by(-1)
      end
  
      it "should redirect to the orderable page" do
        delete :destroy, :id => @orderable, :order_list_id => @order_list.id, :order_listing_id => @order_listing.id, :product_family_id => @product_family.id
        response.should redirect_to(order_list_product_family_order_listing_orderables_path(@order_list,@product_family,@order_listing))
      end
    end
  end
end
