# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :accounts, only: %i[index show create update destroy]
      resources :users, only: %i[index show create update destroy] do
        get :show_me, on: :collection
      end
    end
    namespace :v2 do
      resources :user_accounts, only: %i[index create update destroy]
    end
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post :login, to: 'sessions#create'
    delete :logout, to: 'sessions#destroy'
  end
end
