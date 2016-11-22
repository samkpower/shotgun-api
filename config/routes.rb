Rails.application.routes.draw do
  devise_for :users
  scope 'api/v1', module: 'v1', as: 'v1' do
    resources :users, :only => [:show, :create, :update, :index]
    match '*all' => 'api#preflight_check', via: :options, as: :preflight_check
  end
end
