Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
    end
    collection do
      get :export
    end

    resources :comments, only: [:create]
  end

  resources :comments, only: :destroy

  match "top_users", to: "comments#top_users", via: :get
end
