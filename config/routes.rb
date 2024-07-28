Rails.application.routes.draw do
  api_version = 1

  devise_for :users,
             path: "api/v#{api_version}/auth",
             only: %i[sessions registrations],
             path_names: {
               # Session paths:
               sign_in: 'login',
               sign_out: 'logout',

               # Registration path:
               registration: 'signup'
             },
             controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  namespace :api do
    namespace :v1 do
      get '/auth/current_user', to: 'current_user#index'
      resources :languages, only: %i[index show]
      resources :puzzles
      resources :solutions
      resources :relationships, only: %i[create destroy]
    end
  end
end
