Rails.application.routes.draw do
  post 'oauth/token', to: 'users#token'

  scope 'rest/v2/US' do
    resources :users, only: [:create] do
      collection do
        get :current, to: 'users#show'
        match :current, to: 'users#update', via: [:put, :patch]
        delete :current, to: 'users#destroy'
        post :forgottenpass
      end
    end
  end
end
