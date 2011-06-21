Marketlist::Application.routes.draw do

  resources :product_families

  resources :markets

  resources :order_lists do
    member do 
      get 'email'
      get 'email_invoices'
      get 'redux_by_listing'
      get 'redux_by_user'
      get 'redux_unclaimed'
      get 'redux_by_invoice'
      get 'duplicate'
      get 'preview'
    end
    resources :product_families do 
      resources :order_listings do
        resources :commitments
        resources :orderables
      end
    end
  end

  get "sessions/new"

  resources :users do 
    collection do
      post 'forgot_password'
      get  'reset_password'
    end
    member do 
      get 'request_organic'
    end
    resources :commitments
    resources :invoices do 
      member do 
        get 'email'
      end
    end
    resources :user_family_blocks, :only => [:index] do 
      collection do
        post 'batch_create'
      end
    end
  end
  
  resources :sessions, :only => [:new, :create, :destroy]
  
  get "users/new"

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/admin',   :to => 'pages#admin'
  match '/home',    :to => 'pages#home'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  

  resources :products do 
    collection do 
      post 'create_from_csv'
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
