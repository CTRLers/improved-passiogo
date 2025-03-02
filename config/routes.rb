# config/routes.rb
Rails.application.routes.draw do
  # Existing web routes
  resources :routes, only: [:index, :show]
  resources :stops, only: [:index, :show]
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :routes, only: [:index, :show]
      resources :stops, only: [:index, :show] do
        collection do
          get 'by_route/:route_id', to: 'stops#by_route'
        end
      end
    end
  end
end
