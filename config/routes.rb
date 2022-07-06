Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  api_routes = lambda do
    post "bulk_transfers/:api_token", to: "transactions#bulk_transfers"
  end
  namespace :api do
    namespace :v1, &api_routes
  end
end
