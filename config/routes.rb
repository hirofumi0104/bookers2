Rails.application.routes.draw do
  get 'groups/new'
  get 'groups/index'
  get 'groups/show'
  get 'groups/edit'
  get 'relationships/followings'
  get 'relationships/followers'
  devise_for :users
  root to: "homes#top"
  get "search" => "searches#search"
  get "home/about", to: "homes#about"
  delete 'books/:id' => 'books#destroy', as: 'destroy_book'
  resources :groups, only: [:new, :index, :show, :create, :edit, :update]
  resources :books, only: [:new,  :create, :index, :show, :edit, :update] do
   resource :favorite, only: [:create, :destroy]
   resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update, :create] do
     get "search" => "users#search"
     member do
      get :follows, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
