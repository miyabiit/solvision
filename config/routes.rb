Rails.application.routes.draw do
  resources :monthly_receipts, only: [:index, :new, :edit, :create, :update, :destroy] do
    collection do
      get ':year/:month' => 'monthly_receipts#index'
      put ':year/:month' => 'monthly_receipts#update_all'
    end
  end
  resources :facilities do
    resources :facility_aliases
  end
  resources :facility_capacities
  resources :analysis, only: [:index] do
    collection do
      get ':year' => 'analysis#index'
      get ':year/download' => 'analysis#download'
      get ':year/facilities/:facility_id' => 'analysis#show'
      get ':year/:month/facilities/:facility_id' => 'analysis#show'
    end
  end

  devise_for :users
  get 'api_test/index'
  get 'api_test/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "analysis#index"
end
