Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  root 'games#user_games'

  get "/recordbook/game" => 'recordbook#game_index'
  get "/recordbook/game/espn" => 'recordbook#game_espn'
  get "/recordbook/game/fleaflicker" => 'recordbook#game_fleaflicker'
  get "/recordbook/season" => 'recordbook#season_index'
  get "/recordbook/season/espn" => 'recordbook#season_espn'
  get "/recordbook/season/fleaflicker" => 'recordbook#season_fleaflicker'
  get "/recordbook/all_time" => 'recordbook#all_time_index'
  get "/recordbook/all_time/espn" => 'recordbook#all_time_espn'
  get "/recordbook/all_time/fleaflicker" => 'recordbook#all_time_fleaflicker'

  get "/seasons" => 'seasons#index'

  get "/login" => 'sessions#new', as: :login_path
  post "/login" => 'sessions#create'
  delete "/logout" => 'sessions#destroy', as: :logout

  match '*_missing_page', to: 'pages#not_found', via: :get
end
