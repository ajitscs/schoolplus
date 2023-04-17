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


end
