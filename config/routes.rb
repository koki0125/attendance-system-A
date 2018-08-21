Rails.application.routes.draw do

  root   'home#top'
  post   '/login',   to: 'sessions#create'
  get   '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  get    '/signup',  to: 'users#new'

  get 'users/edit'

  get 'users/index'

  get 'attendance/show'

  get 'attendance/edit'

  get 'home/top'
  get 'home/edit'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]  
  


 
end
