Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get 'home' => 'users#home'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  get 'login' => 'sessions#login'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#logout'

  get 'auth/:provider/callback', to: 'sessoins#googleAuth'
  get 'auth/failure' to: redirect_to root_path


  resources :users do 
    resources :topics
    resources :posts
    resources :messages
    resources :classrooms
  end

  resources :users, only: [:new, :create, :show]

  resources :topics do
    resources :posts
  end

  resources :classrooms

end
