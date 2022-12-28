# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post :login, to: 'sessions#create'
    delete :logout, to: 'sessions#destroy'
  end
end
