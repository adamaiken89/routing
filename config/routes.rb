# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Generate Two Routes
  # 1) POST /route: Submit start point and drop-off locations
  post '/route', to: 'route#routing', defaults: { format: :json }

  # 2) GET /route/<token>: Get the shortest driving route
  get '/route/:token', to: 'route#driving_info', defaults: { format: :json }

  # Home Url
  root to: 'home#index'
  match '/*path', to: redirect('/'), via: %i[get post]
end
