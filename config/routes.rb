Rails.application.routes.draw do
  root "routes#index"

  resources :routes, only: [ :index, :show ]
  resources :stops, only: [ :index, :show ]



  devise_for :users, controllers: {
    registrations: "devise/registrations",
    sessions: "devise/sessions",
    passwords: "devise/passwords",
    confirmations: "devise/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [ :show ] do
    resources :route_subscriptions, only: [ :create, :destroy ]
    resources :stop_subscriptions, only: [ :create, :destroy ]
  end






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
