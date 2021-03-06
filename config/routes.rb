Shouter::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, skip: [:session, :password, :registration, :confirmation], :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

    # resources :profiles , only: [:show] 
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
  # scope "(:locale)", :locale => /en|fa/ do

  get "superadmins" => "superadmins#index"
  get "superadmins/trips"
  get "superadmins/messages"


    resource  :search_subtrips, only: [] do
      get 'special_events' => 'search_subtrips#special_events'
      get 'search' => 'search_subtrips#search'
      get 'choose_search_mode' => 'search_subtrips#choose_search_mode'
    end

    resources :subtrips, only: [:show, :edit, :update]
    resources :bookings do
      get 'booking_acceptance', on: :collection
      get 'booking_response', on: :collection
      # resources :notifications, only: [:create]
    end

    resource  :invitation, only: [:show, :create] do
      member do
        get 'invite_acceptation'
      end
    end

    resources :pages do
      collection do
        get 'contact'
        post 'contact_accept'
        get 'company_account_request'
        post 'company_account_request_accept'
      end
    end

    resources :spacial_events do
      get 'special_events1', on: :collection
    end

    get 'trips/start_new_trip'     => 'trips#start_new_trip'
    get 'trips/select_driver'      => 'trips#select_driver'
    put 'trips/accept_driver'      => 'trips#accept_driver'
    get 'trips/select_date_format' => 'trips#select_date_format'
    put 'trips/accept_date_format' => 'trips#accept_date_format'
    get 'trips/select_period' => 'trips#select_period'
    put 'trips/accept_period' => 'trips#accept_period'

    resources :trips do
      resources :comments
    end

    resources :photo_shouts, only: [:create, :destroy] do
      resources :comments
    end
    
    resources :companies do
      resources :branches do
        post   'driver' => 'branch_driver_relationships#create' 
        delete 'driver' => 'branch_driver_relationships#destroy' 
      end
    end

    resources :contacts , only: [:index, :show, :create, :update] do
      resources :messages, only: [:create, :update]
    end
    resources :networks, only: [:show]
    resources :currencies
    resources :vehicle_brands do
      resources :vehicle_models
    end
    resource  :search, only: [:show]
    resource  :dashboard, only: [:show,:create]  
    
    get 'lang_select'  => 'homes#lang_select'
    resources :homes, only: [:show]

    resources :shouts, only: [:show]
    resources :text_shouts, only: [:create, :destroy]
    resources :hashtags, only: [:show]

    resources :profiles, only: [:show] do
      get 'all_trips', on: :member
    end
    
    root 'homes#show'

    devise_for :users, :controllers => { registrations: 'users' }, skip: [:omniauth_callbacks]
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
