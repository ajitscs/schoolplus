Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :schools do
    resources :courses do
      resources :batches
    end
  end

  resources :users
  
  resources :batches, only: [] do    
    collection do
      get :enrol
    end
    
    resources :student_batches, only: [:index, :create] do
      patch :approve
      patch :deny
    end
  end

  get 'classmates', to: 'student_batches#classmates'
end
