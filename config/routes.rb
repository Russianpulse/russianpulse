Rails.application.routes.draw do
  scope :dashboard do
    get '/' => 'dashboard#index'
    get 'stream_count/:stream' => 'dashboard#stream_count'
    put 'update_post' => 'dashboard#update_post'
  end

  get 'goto' => 'redirects#bye', as: :goto

  get 'ratings/posts'

  devise_for :users
  resources :comments, only: [:create]

  get 'robots.txt' => 'robots#index'

  get 'welcome/index'

  get 'errors/routing'

  get 'errors/not_found'

  get 'errors/exception'

  root 'welcome#index'
  get ':blog/:year/:month/:day/:id' => "posts#show", :as => :post
  get ':blog/:year/:month/:day/:slug_id/:title' => "posts#show", :as => :post_with_slug
  get 'posts/:slug_id' => "posts#show", as: :post_permalink

  get 'widgets' => 'widgets#index'
  get 'w/p/:id' => 'widgets#post'
  get 'w/:action', controller: 'widgets'

  get '/p/views/:id' => 'posts#counter'


  get 'digest/:slug' => 'post_digests#show', :as => :digest


  get 'about' => 'static#about', as: :about

  get 'search' => 'search#index', :as => :search

  get 'tools/:action', :controller => :tools
  post 'tools/:action', :controller => :tools
  get 'tools' => "tools#index"

  get 'tags/:tag' => "tags#show", :as => :tag

  get 'recent' => "posts#index", :as => :posts

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get "/main" => "posts#index" # legacy
  get ':slug' => "blogs#show", :as => :blog

  get '*a', :to => 'errors#not_found'

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
