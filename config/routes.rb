Rails.application.routes.draw do

  get 'bases/edit'

  resources :users
  resources :bases
  resources :attendances
  resources :password_resets,         only: [:new, :create, :edit, :update]
  
  # home
  root   'home#top'
  get    '/rule',                     to: 'home#rule'
  
  # sessions
  post    '/login',                   to: 'sessions#create'
  get     '/login',                   to: 'sessions#new'
  delete  '/logout',                  to: 'sessions#destroy'
      
  # users   
  get     '/signup',                  to: 'users#new'
  post    '/startedtime_create',      to: 'users#started_time'
  post    '/finishedtime_creat',      to: 'users#finished_time'
  post    '/csv_import',              to: 'users#csv_import'
  post    '/csv_export',              to: 'users#csv_export' 
  get     'home/top'
  get     '/basic_info/:id',          to: 'users#basic_info', as:"basic_info"
  post    '/basic_info_edit/:id',     to: 'users#basic_info_edit', as:"basic_info_edit"
  get     '/working_employees_index', to: 'users#working_employees_index'
  
  # attendances
  # １ヶ月分の勤怠承認申請
  patch   '/submit_month',            to: 'attendances#submit_month'
   
  # 勤怠変更申請
  post    '/update_all',              to: 'attendances#update_all'
  
  # 残業申請
  get     '/form_overtime',           to: 'attendances#form_overtime'
  patch   '/submit_overtime',         to: 'attendances#submit_overtime'

# 上長ユーザー
  # 所属長承認　確認・承認
  get     '/check_approval',          to: 'attendances#check_approval'
  patch   '/res_approval',            to: 'attendances#res_approval'
  # 勤怠変更　確認・承認
  get     '/check_modified',          to: 'attendances#check_modified'
  patch   '/res_modified',            to: 'attendances#res_modified'
  # 残業申請　確認・承認
  get     '/check_overtime',          to: 'attendances#check_overtime'
  patch   '/res_overtime',            to: 'attendances#res_overtime'
  
  # 勤怠修正ログ
  get     '/modified_log',        to: 'attendances#modified_log'

end
