require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'admin'" do
  
    describe "as a non-admin user" do
      before(:each) do
        @user = Factory(:user)
      end
      
      it "should protect the page" do
        test_sign_in(@user)
        get 'admin'
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do 
      
      before(:each) do
        adm = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(adm)
      end
      
      it "should be successful" do
        get 'admin'
        response.should be_success
      end
    
      it "should have the right title" do
        get 'admin'
        response.should have_selector("title",
                        :content => "| Site Management")
      end
    end
  
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                        :content => "| Contact")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => "| About")
    end
  end
  

end
