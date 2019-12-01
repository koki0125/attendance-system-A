Rails.application.routes.draw do

  get 'bases/edit'

  resources :users
  resources :attendances
  resources :password_resets,         only: [:new, :create, :edit, :update]
  
  
  root   'home#top'
  # sessions
  post    '/login',                   to: 'sessions#create'
  get     '/login',                   to: 'sessions#new'
  delete  '/logout',                  to: 'sessions#destroy'
      
  # users   
  get     '/signup',                  to: 'users#new'
  post    '/startedtime_create',      to: 'users#started_time'
  post    '/finishedtime_creat',      to: 'users#finished_time'
  post    '/csv_import',              to: 'users#csv_import'
  get     'home/top'
  get     '/basic_info/:id',          to: 'users#basic_info', as:"basic_info"
  post    '/basic_info_edit/:id',     to: 'users#basic_info_edit', as:"basic_info_edit"
  get     '/working_employees_index', to: 'users#working_employees_index'
  
   # attendances
  post    '/update_all',              to: 'attendances#update_all'
  # 残業申請
  get     '/form_overtime',           to: 'attendances#form_overtime'
  patch   '/submit_overtime',         to: 'attendances#submit_overtime'
  # get '/overtime', to: 'attendances#overtime' これ使ってない気がする
  # 残業確認・承認
  get     '/check_overtime',          to: 'attendances#check_overtime'
  patch   '/res_overtime',            to: 'attendances#res_overtime'
  # bases
  get     '/base_edit/',              to: 'bases#edit'
end
