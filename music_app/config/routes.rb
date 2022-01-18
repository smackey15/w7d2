Rails.application.routes.draw do
  resources :users, only: [:new, :show, :create]
  resource :session, only: [:new, :destroy, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
