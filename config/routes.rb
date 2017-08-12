Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/index'

  get 'pages/home'

  get 'pages/about'

  get 'pages/contact'

  get 'pages/pages'

  get 'pages/pricing'
  devise_for :users

  resources :users
  get 'users/index'

  get 'users/show'





  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
