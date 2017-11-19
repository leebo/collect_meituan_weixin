require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :merchants do
    collection do
      get :deleteall
      get :priceasc
      get :pricedesc
      get :scoreasc
      get :scoredesc
    end
  end
  resources :users
  resources :citys do
    member do
      get :collect
    end
    collection do
      get :collectcity
      get :deleteall
    end
  end
  resources :daijinjuans do
    collection do
      get :originpriceasc
      get :originpricedesc
      get :priceasc
      get :pricedesc
      get :soldsasc
      get :soldsdesc
    end
  end
  resources :maidans
  resources :tuangous do
    collection do
      get :originpriceasc
      get :originpricedesc
      get :priceasc
      get :pricedesc
      get :soldsasc
      get :soldsdesc
    end
  end
  # sidekiq网页客服端
  mount Sidekiq::Web => '/admin/sidekiq'
  root to: "merchants#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
