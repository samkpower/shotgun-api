Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks' }

  scope 'api/v1', module: 'v1', as: 'v1' do
    resources :users, :only => [:show, :create, :update, :index]
    resources :events, :only => [:show, :create, :update, :index, :destroy]
  end
end
