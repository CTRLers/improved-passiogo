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
