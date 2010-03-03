Scurvy::Application.routes.draw do
  match '/location/:id' => 'downloads#download_file', :as => :download_file
  match '/release/:id' => 'downloads#download_release', :as => :download_release
  
  resources :invitations do
    member do
      get :resend
    end
  end

  resources :artists do
    collection do
      get :autocomplete_for_artist_name
    end
  end

  resources :albums do
      resources :tracks
      collection do
        get :autocomplete_for_album_name
      end
  end

  resources :tracks do
    collection do
      get :autocomplete_for_track_name
    end
  end

  resources :movies do
    collection do
        get :autocomplete_for_movie_title
    end
    member do
      post :imdbfetch
      get :imdb
    end
  end

  resources :releases
  
  resources :downloads do
    member do
      post :approve
    end
  end

  match '/login' => 'user_sessions#new', :as => :login, :via => 'get'
  match '/login' => 'user_sessions#create', :via => 'post'
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/signup/:invitation_token' => 'users#new', :as => :signup, :via => 'get'
  match '/signup/:invitation_token' => 'users#create', :as => :signup, :via => 'post'
  match '/' => 'user_sessions#new'
  resource :account, :controller => "users"
  resources :users
  match '/:controller(/:action(/:id))'
end
