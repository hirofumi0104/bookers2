Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "home/about", to: "homes#about"
  resources :books, only: [:new,  :create, :index, :show, :edit, :update]
  resources :users, only: [:index, :show, :edit, :update, :create]
  delete 'books/:id' => 'books#destroy', as: 'destroy_book'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
