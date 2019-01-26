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

  get 'messages/inbox' => 'messages#inbox', as: "inbox"
  get 'messages/threads/users/:id' => 'messages#thread', as: 'messages_from_user'
  # get 'messages/users/:user_id/new' => 'messages#new', as: "new_message_for_reciever"
  post 'messages/new/find_reciever' => 'messages#find_reciever', as: 'message_finder'

 
  
  resources :posts, only: [:show]


  resources :topics do
    resources :posts, only: [:new, :create, :edit, :update, :index, :destroy]
  end

  resources :tag_types, only: [:index]

  resources :tags do 
    resources :topics, only: [:index, :show]
    resources :classrooms, only: [:index, :show]
  end

  resources :classrooms do 
    resources :topics
  end
 

  resources :users do 
    resources :topics
    resources :posts
    resources :messages, only: [:new, :create]
    resources :classrooms
    resources :notifications, only: [:index]
  end

  

  resources :users, only: [:new, :create, :show]

 
  post 'users/:user_id/classrooms/:id/find_student' => 'classrooms#find_student', as: 'student_finder'
  get 'users/:user_id/classrooms/:id/students' => 'classrooms#students', as: 'classroom_students'
  delete 'classrooms/:classroom_id/student/:id' => 'classrooms#destroy_student', as: 'delete_classroom_student'
  post 'classrooms/:id/enroll' => 'classrooms#enroll_student', as: 'classroom_user_enroll'


  get 'admin/home' => 'admin#home', as: 'admin_home'
  get 'admin/reports/topics' => 'admin#reported_topics', as: 'reported_topics'
  get 'admin/reports/posts' => 'admin#reported_posts', as: 'reported_posts'
  get 'admin/users' => 'admin#display_users', as: 'admin_view_users'
  delete 'admin/topics/:id' => 'admin#destroy_topic', as: 'admin_delete_topic'
  delete 'admin/users/:id' => 'admin#destroy_user', as: 'admin_delete_user'
  delete 'admin/posts/:id' => 'admin#destroy_post', as: 'admin_delete_post'
  delete 'admin/reports' => 'admin#destroy_reports', as: 'admin_destroy_reports'

  post 'api/users/check-email' => 'api#check_email'
  get 'api/users/logged-in' => 'api#logged_in'
  get 'api/users/current-user' => 'api#get_current_user'
  get 'api/topics/recent' => 'api#most_recent_topics'
  get 'api/users/current-user/reactions' => 'api#user_reactions'
  get 'api/users/current-user/:reactable/:reactable_id/:reaction' => 'api#query_reacted_reactables'
  get 'api/reactions/users/:user_id/:reactable/:reactable_id' => 'api#user_reactable_reaction'
end
