Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  get 'login' => 'sessions#login'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#logout'

  get 'auth/google_oauth2/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')

  post 'topics/:topic_id/save-for-later' => 'users#reading_list_create', as: "create_reading_list"
  get 'reading-list' => 'topics#reading_list', as: "reading_list"

  get 'posts/:post_id/replies' => "posts#index", as: "post_replies"
  get 'posts/:post_id/replies/new' => "posts#new", as: "new_post_reply"
  get 'posts/:post_id/replies/:id' => "posts#show", as: "post_reply"
  get 'posts/:post_id/replies/:id/edit' => "posts#edit", as: "edit_post_reply"
  post 'posts/:post_id/replies' => "posts#create"
  patch 'posts/:post_id/replies/:id' => "posts#update"
  delete 'posts/:post_id/replies/:id' => "posts#destroy", as: "delete_post_reply"

  post 'topics/:topic_id/reactions/:reaction_type_id' => "reactions#create", as: "create_topic_reaction"
  post 'posts/:post_id/reactions/:reaction_type_id' => 'reactions#create', as: "create_post_reaction"

  get 'dashboard' => "users#dashboard", as: "dashboard"

  get 'dashboard/followers' => "users#followers", as: "followers"
  get 'dashboard/following' => "users#following", as: "following"
  get 'users/:user_id/topics' => "topics#index", as: "user_topics"

  post 'users/:id/follow' => 'users#follow', as: "follow_user"
  get 'users/:id/followers' => 'users#followers', as: "users_following"
  post 'users/:id/following' => 'users#following', as: "following_users"


  resources :topics do
    resources :posts, only: [:new, :create, :edit, :update, :index, :destroy]
  end

  resources :tag_types, only: [:index]

  resources :tags do 
    resources :topics, only: [:index, :show]
    resources :classrooms, only: [:index, :show]
  end
 

  resources :users do 
    resources :topics
    resources :posts
    resources :messages
    resources :classrooms
    resources :notifications, only: [:index]
  end

  

  resources :users, only: [:new, :create, :show]

  resources :classrooms

end
