Rails.application.routes.draw do

  root to: 'tops#index'

  resources :pictures do
    collection do
      post :confirm
    end
  end

  resources :users

  resources :sessions, only: [:new, :create, :destroy]

  resources :favorites, only: [:create, :show, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener"

end
