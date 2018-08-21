Rails.application.routes.draw do
  
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]  
  root   'home#top'
  post   '/login',   to: 'sessions#create'
  get   '/login',   to: 'sessions#new'
  get    '/signup',  to: 'users#new'

  get 'users/edit'

  get 'users/index'

  get 'attendance/show'

  get 'attendance/edit'

  get 'home/top'
  get 'home/edit'
  

namespace :admin do

end
 
end
