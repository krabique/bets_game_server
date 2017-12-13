Rails.application.routes.draw do
  resources :accounts
  resources :bets
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  
  get 'home/index'
end
