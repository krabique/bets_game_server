Rails.application.routes.draw do
  resources :accounts, only: [:new, :edit, :create, :update]
  post 'bets', to: 'bets#create'

  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  get 'home/index'
end
