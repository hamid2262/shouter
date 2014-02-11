Shouter::Application.routes.draw do
    # resources :profiles , only: [:show] 
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    resource  :search_subtrips, only: [] do
      get 'special_events' => 'search_subtrips#special_events'
      get 'search' => 'search_subtrips#search'
      get 'choose_search_mode' => 'search_subtrips#choose_search_mode'
    end
    resources :subtrips, only: [:show]
    resources :bookings do
      get 'booking_acceptance', on: :collection
    end

    resource  :invitation, only: [:show, :create] do
      member do
        get 'invite_acceptation'
      end
    end

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
        get 'refresh' => 'users#refresh'
        resource :vehicles, only: [ :new, :create,:edit, :update ]
        post 'follow' => 'following_relationships#create' 
        delete 'follow' => 'following_relationships#destroy' 
      end
    end
    
    get 'upgrade_cities' => 'cities#upgrade'
  end
    

  get '*id/:locale' => 'profiles#show'
  get '*id', to: redirect("/%{id}/#{I18n.default_locale}")

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  get '', to: redirect("/#{I18n.default_locale}")

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
