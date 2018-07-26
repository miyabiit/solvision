Rails.application.routes.draw do
  resources :facilities
  resources :facility_capacities

  devise_for :users
  get 'api_test/index'
  get 'api_test/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "api_test#index"
end
