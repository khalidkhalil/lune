Rails.application.routes.draw do
  resources :movies do
    collection do
      post 'import_csv'
    end
    resources :reviews
  end

  # resources :movies
  resources :reviews

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "movies#index"
end
