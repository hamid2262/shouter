Shouter::Application.routes.draw do

  resource  :search_subtrips, only: [:show] do
    get 'search' => 'search_subtrips#search'
    get 'choose_search_mode' => 'search_subtrips#choose_search_mode'
  end
  resources :subtrips, only: [:show]
  resources :bookings

  resources :trips
  resources :cities
  resources :states
  resources :countries
  resources :vehicle_brands
  resources :vehicle_models
  resource  :search, only: [:show]
  resource  :dashboard, only: [:show,:create]  
  resources :homes, only: [:show]
  resources :shouts, only: [:show]
  resources :text_shouts, only: [:create, :destroy]
  resources :photo_shouts, only: [:create, :destroy]
  resources :hashtags, only: [:show]
  
  root 'homes#show'

  devise_for :users, :controllers => { registrations: 'users' }
  devise_scope :user do
    resources :users, only: [:show, :index] do
      resource :vehicles, only: [ :new, :create,:edit, :update ]
      post 'follow' => 'following_relationships#create' 
      delete 'follow' => 'following_relationships#destroy' 
    end
  end

  
  get 'upgrade_cities' => 'cities#upgrade'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
