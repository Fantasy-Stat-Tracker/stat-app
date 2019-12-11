Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  root 'games#user_games'

  get "/recordbook" => 'recordbook#index'
  get "/recordbook/espn" => 'recordbook#espn'
  get "/recordbook/fleaflicker" => 'recordbook#fleaflicker'

  get "/seasons" => 'seasons#index'

  get "/login" => 'sessions#new', as: :login_path
  post "/login" => 'sessions#create'
  delete "/logout" => 'sessions#destroy', as: :logout

  match '*_missing_page', to: 'pages#not_found', via: :get
end
