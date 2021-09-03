Rails.application.routes.draw do
  root 'users#login'
  post 'login' => 'sessions#login'
  get 'logout' => 'sessions#logout'

  patch 'tasks/:id' => 'tasks#update'
  patch 'projects/:id' => 'projects#update'

  post '/users' => 'users#create'
  
  resources :users, :projects, :tasks
end
