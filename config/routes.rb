Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'users/sign_out', to: 'sessions#destroy'
  end

  resource :authorizations do
    get :callbacks
  end

  resources :google_events, only: [:index]

  scope 'api/v1', module: 'v1', as: 'v1' do
    resources :users, only: %i[show create update index]
    resources :events, only: %i[show create update index destroy]
    resources :to_dos, only: %i[show create update index destroy]
  end

  root 'google_events#index'
end
