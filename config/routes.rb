Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :profiles do 
    collection do
      get 'self'
    end
  end
  resources :devices
  resources :posts

  resources :users do
    member do
      get 'dashboard'
    end
    collection do
      get 'access'
    end
  end

end
