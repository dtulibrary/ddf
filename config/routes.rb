Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Spotlight::Engine, at: 'spotlight'
  mount DtuBlacklightCommon::Engine, at: '/'
  devise_for :users
  get 'messages/new'

  get 'messages/create'

  get 'messages/message_params'

  scope "(:locale)", :locale => /en|da/ do

    get '/selected', to: 'bookmarks#index'

    # root :to => "catalog#index"
    # blacklight_for :catalog
    root to: "catalog#index"
    blacklight_for :catalog
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    get 'citations/new', as: 'new_citations'
    get 'citations/preview', as: 'preview_citations'
    post 'citations/send', to: 'citations#send_citations', as: 'send_citations'
    # You can have the root of your site routed with "root"
#  root 'pages#index' # replaced by spotlight root path
  # For the visualization dataset. Use another URL (end path) than 'data':
  # get 'pages/data', :defaults => { :format => 'json' }

  # SEARCH
  # Don't do a 301 redirect:
  # get '/search', to: redirect('/')
  # get '/catalog', to: redirect('/')

  get '/search', to: 'pages#index'
  get '/catalog', to: 'pages#index'

  # OPEN ACCESS
  get '/open-access' => 'pages#open_access'

  # ELITEFORSK AWARD
  get '/eliteforsk-award' => 'pages#eliteforsk_award'

  # ABOUT
  get 'about' => 'pages#about'
  get 'about/search-and-get' => 'pages#search_and_get'

  # get 'about/indicators' => 'pages#indicators'
  # get 'about/actuality' => 'pages#actuality'

  get 'about/data' => 'pages#data'
  get 'about/faq' => 'pages#faq'
  get 'about/contact' => 'pages#contact'

  # OTHER
  get 'pattern-library' => 'pages#pattern_library'

  # FEEDBACK
  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'

  # ROBOTS
  get '/robots', to: 'pages#robots'

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
end
