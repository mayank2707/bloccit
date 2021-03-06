Bloccit::Application.routes.draw do

  get "posts/index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  resources :users, only: [:show, :index]
  
  # call the resources method, and pass it the :topics & :posts symbols
  # this instructs Rails to create routes for every CRUD action
  resources :posts, only: [:index]
  resources :topics do

    # Give Posts a nested route within topics
    # Posts has a URL scoped to topic to follow RESTful conventions
    # i.e. /topics/1/posts/3
    resources :posts, except: [:index], controller: 'topics/posts' do
      resources :comments, only: [:create, :destroy]
      match '/up-vote', to: 'votes#up_vote', as: :up_vote
      match '/down-vote', to: 'votes#down_vote', as: :down_vote
      resources :favorites, only: [:create, :destroy] 
    end
  end 

  match "about" => 'welcome#about', via: :get

  root to: 'welcome#index'

end