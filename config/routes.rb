Rails.application.routes.draw do
  root 'welcome#index'

  scope path: '/archive', controller: :archive do
    get '/', action: :index, as: :archive
    get '/:year/:month/:day', action: :day, as: :archive_day
  end

  get 'goto', to: redirect('/')

  get 'ratings/posts', as: :rating

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :comments, only: [:create] do
    member do
      put :spam
      put :upvote
      put :downvote
    end
  end

  get 'robots.txt' => 'robots#index'
  get 'sitemap.xml' => 'robots#sitemap'

  get 'welcome/index'

  get 'errors/routing'

  get 'errors/not_found'

  get 'errors/exception'

  get '/p/views/:id' => 'posts#counter'

  get 'digest/:slug' => 'post_digests#show', :as => :digest

  get 'about' => 'static#about', as: :about

  get 'search' => 'search#index', :as => :search

  scope path: '/tools', controller: 'tools' do
    get '/', action: :index
    get 'cleanup', action: :cleanup
    post 'cleanup', action: :cleanup
  end

  get 'tags/:tag' => 'tags#show', :as => :tag

  get 'recent' => 'posts#index', :as => :posts

  scope path: '/admin' do
    mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

    scope :dashboard do
      get '/' => 'dashboard#index'
      get 'stream_count/:stream' => 'dashboard#stream_count'
      put 'update_post' => 'dashboard#update_post'
    end

    scope :health, module: :admin do
      get '/' => 'health#index'
    end
  end

  get '/sitemap.xml(:gz)', to: redirect("https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz")

  resources :blogs, only: :index

  put '/posts/:id/block' => 'posts#block', as: :block_post

  get ':blog/:year/:month/:day/:id' => 'posts#show', :as => :post
  get ':blog/:year/:month/:day/:slug_id/:title' => 'posts#show', :as => :post_with_slug
  get 'posts/:slug_id' => 'posts#show', as: :post_permalink

  scope '/ajax', ajax: true do
    scope '/comments' do
      get '/recent' => 'comments#recent', as: :ajax_comments_recent
    end
    scope '/posts' do
      get '/most_discussed' => 'posts#most_discussed', as: :ajax_posts_most_discussed
      get '/comments' => 'posts#comments', as: :ajax_post_comments
    end

    get '/cells/:name' => 'ajax/cells#show', as: :ajax_cell
  end

  scope '/editor', module: :blogs do
    resources :posts
  end

  get '/main' => 'posts#index' # legacy
  get ':slug' => 'blogs#show', :as => :blog

  if Rails.env.development?
    # get '/rails/mailers' => 'rails/mailers#index'
    # mount LetterOpenerWeb::Engine, at: '/rails/inbox'
  else
    get '*a', to: 'errors#not_found'
  end

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
