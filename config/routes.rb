Rails.application.routes.draw do

  resources :users
  resources :attendances
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  root   'home#top'
  post   '/login',   to: 'sessions#create'
  get   '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  get    '/signup',  to: 'users#new'
  post '/startedtime_creat', to: 'users#started_time'
  post '/finishedtime_creat', to: 'users#finished_time'
  
  get 'home/top'
  get '/basic_info/:id',  to: 'users#basic_info', as:"basic_info"
  post'/basic_info_edit/:id', to: 'users#basic_info_edit', as:"basic_info_edit"
  
  post '/update_all', to: 'attendances#update_bunch'

    
end
