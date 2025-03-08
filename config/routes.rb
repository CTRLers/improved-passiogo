Rails.application.routes.draw do
  resources :routes, only: [ :index, :show ]
  resources :stops, only: [ :index, :show ]

  resources :users, only: [ :new, :create, :show, :destroy ] do
    resources :route_subscriptions, only: [ :create, :destroy ], param: :route_id
    resources :stop_subscriptions, only: [ :create, :destroy ], param: :stop_id
  end

  root "home#index"

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
