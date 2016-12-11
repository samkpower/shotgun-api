Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  scope 'api/v1', module: 'v1', as: 'v1' do
    resources :users, :only => [:show, :create, :update, :index]
    resources :events, :only => [:show, :create, :update, :index, :destroy]
    match '*all' => 'api#preflight_check', via: :options, as: :preflight_check
  end
end
