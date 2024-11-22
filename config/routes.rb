Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]

      resources :files, only: [] do
        post 'upload', on: :collection
      end
    end
  end
end
