# config/routes.rb
Rails.application.routes.draw do
  get "stop_subscriptions/create"
  get "stop_subscriptions/destroy"
  get "route_subscriptions/create"
  get "route_subscriptions/destroy"
  get "users/new"
  get "users/create"
  get "users/show"
  get "users/destroy"
  # Existing web routes
  resources :routes, only: [ :index, :show ]
  resources :stops, only: [ :index, :show ]
  resources :users, only: [ :new, :create, :show, :destroy ] do
    resources :route_subscriptions, only: [ :create, :destroy ], param: :route_id
    resources :stop_subscriptions, only: [ :create, :destroy ], param: :stop_id
  end
  # API routes
  namespace :api do
    namespace :v1 do
      resources :routes, only: [ :index, :show ]
      resources :stops, only: [ :index, :show ] do
        collection do
          get "by_route/:route_id", to: "stops#by_route"
        end
      end
    end
  end
end
