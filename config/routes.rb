Rails.application.routes.draw do
  post 'award/create'

  root 'auth#loginpage'

  post 'story/create'

  post 'story/change_status'

  post 'story/update'

  post 'story/update_title'

  post 'story/update_description'

  post 'story/set_award'

  post 'story/set_points'

  get 'story/delete'

  post 'task/create'

  get 'task/delete'

  post 'task/change_status'

  post 'comment/create'

  get 'project' => 'project#index'

  get 'project/index'

  get 'project/show'

  post 'project/create'

  get 'project/delete'

  post 'project/update'

  post 'project/setPanelOptions'

  post 'project/getCurrentProject'

  get 'auth/signup' => 'auth#new'

  post 'auth/signup'

  get 'auth/login' => 'auth#loginpage'

  post 'auth/login'

  post 'auth/update'

  get 'auth/activate'

  get 'auth/logout'

  get 'user/detail' => 'auth#detail'

  match "*any", :to => "errors#not_found", via: :get
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
