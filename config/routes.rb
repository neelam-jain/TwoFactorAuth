Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resource :accounts, only: [:edit] do
    member do
      get 'edit_password'
      patch 'update_password'
      post 'enable_two_factor'
      delete 'disable_two_factor'
    end
  end

  get '/login/otp', to: 'sessions#login_otp', as: :login_otp
  post '/verify_otp', to: 'sessions#verify_otp', as: :verify_otp
  get '/dashboard', to: 'home#dashboard', as: :dashboard
  delete '/logout', to: 'sessions#destroy', as: :logout
  get 'confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email'
  root to: 'users#new'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
