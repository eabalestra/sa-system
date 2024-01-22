Rails.application.routes.draw do
  devise_for :users, skip: :registrations

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :clients, except: %i[show]
  resources :suppliers, except: %i[show]
  resources :products, except: %i[show]
  resources :sales, except: %i[show, update] do
    member do
      get :receipt
    end
  end

  get 'product_finder/:term', to: 'products#finder'
  post '/add_item_sale', to: 'sales#add_item'

  get 'client_finder/:term', to: 'clients#finder'
  post '/add_client_sale', to: 'sales#add_client'
end
