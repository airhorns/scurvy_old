ActionController::Routing::Routes.draw do |map|
  
  map.download_file    '/location/:id', :controller => "downloads", :action => "download_file"
  map.download_release '/release/:id', :controller => "downloads", :action => "download_release"
  
  map.resources :invitations, :member => { :resend => :get }
  map.resources :artists, :collection => { :autocomplete_for_artist_name => :get}
  map.resources :albums, :collection => { :autocomplete_for_album_name => :get} do |album|
    album.resources :tracks
  end
  map.resources :tracks, :collection => { :autocomplete_for_track_name => :get}
    

  map.resources :movies, :member => { :imdb => :get, :imdbfetch => :post}, :collection => { :autocomplete_for_movie_title => :get}
  map.resources :releases
  map.resources :downloads, :member => { :approve => :post }, :only => [:index, :edit, :update, :show]
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  map.login '/login', :controller => "user_sessions", :action => "new", :conditions => { :method => :get }
  map.connect '/login', :controller => "user_sessions", :action => "create", :conditions => { :method => :post }
  
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"
  
  
  map.signup  '/signup/:invitation_token', :controller => "users", :action => "new", :conditions => { :method => :get }
  map.signup  '/signup/:invitation_token', :controller => "users", :action => "create", :conditions => { :method => :post }
  
  map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route
  
  map.resource :account, :controller => "users"
  map.resources :users
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
