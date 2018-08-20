Rails.application.routes.draw do
  resources :users
  root   'home#top'
  post   '/login',   to: 'sessions#login'
  get    '/signup',  to: 'users#signup'

  get 'users/edit'

  get 'users/index'

  get 'attendance/show'

  get 'attendance/edit'

  get 'home/top'
  get 'home/edit'
  
 
end
