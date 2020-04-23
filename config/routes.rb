Rails.application.routes.draw do

#   get 'pay_grades/index'
#   get 'pay_grades/new'
#   get 'pay_grades/show'
#   get 'pay_grades/edit'
#   get 'pay_grade_rate/index'
#   get 'pay_grade_rate/show'
#   get 'pay_grade_rate/new'
#   get 'pay_grade_rate/edit'
#   get 'pay_grade/index'
#   get 'pay_grade/show'
#   get 'pay_grade/edit'
#   get 'pay_grade/new'
#   get 'jobs/index'
#   get 'jobs/show'
#   get 'jobs/edit'
#   get 'jobs/new'
#   get 'shift_jobs/index'
#   get 'shift_jobs/show'
#   get 'shift_jobs/new'
#   get 'shift_jobs/edit'

#   get 'shifts/index'
#   get 'shifts/show'
#   get 'shifts/new'
#   get 'shifts/edit'
    # Semi-static page routes
    resources :sessions
    get 'login' => 'sessions#new', :as => :login
    get 'signup' => 'employees#new', :as => :signup
    get 'user/edit' => 'employeess#edit', :as => :edit_current_employee

    get 'logout' => 'sessions#destroy', :as => :logout
    get '', to: 'home#index', as: :home
    get 'home/about', to: 'home#about', as: :about
    get 'home/contact', to: 'home#contact', as: :contact
    get 'home/privacy', to: 'home#privacy', as: :privacy
    get 'home/search', to: 'home#search', as: :search
 

  # Your routes go here
  resources :stores
  resources :employees
  resources :shifts
  resources :assignments
  resources :shift_jobs
  resources :jobs
  resources :pay_grades
  resources :pay_grade_rates


end
