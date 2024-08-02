Rails.application.routes.draw do
  api_version = 1

  devise_for :users,
             path: "api/v#{api_version}",
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
      get '/current_user', to: 'current_user#index'
      get '/current_user/followers', to: 'current_user#followers'
      get '/current_user/following', to: 'current_user#following'
      get '/current_user/completed_solutions', to: 'current_user#completed_solutions'
      get '/current_user/solved_puzzles', to: 'current_user#solved_puzzles'
      get '/current_user/created_puzzles', to: 'current_user#created_puzzles'
      get '/puzzles/random', to: 'puzzles#random'
      resources :users, only: %i[index show]
      resources :languages, only: %i[index show]
      resources :puzzles do
        resources :solutions do
          resources :likes, only: %i[create destroy]
        end
      end
      resources :relationships, only: %i[create destroy]
    end
  end
end
