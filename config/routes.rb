Rails.application.routes.draw do
  root to: 'users#index'
  get 'users/:id/my_page', to: 'users#my_page', as: :user_my_page
  post '/users/:user_id/menus/confirm', to: 'menus#confirm', as: :confirm_user_menu
  post 'users/:user_id/menus/units', to: 'menus#units'

  # ユーザーが作成した献立用のルーティング
  get 'users/:user_id/custom_menus', to: 'menus#custom_menus', as: :user_custom_menus

  # 標準献立用のルーティング
  get 'sample_menus', to: 'menus#sample_menus', as: :sample_menus

  # CartItem#createへのルーティング
  resources :cart_items
  resources :shopping_lists

  # カートアイテムの数量を増やす
  post '/cart_items/:id/increment', to: 'cart_items#increment', as: 'cart_item_increment'
  # カートアイテムの数量を減らす
  post '/cart_items/:id/decrement', to: 'cart_items#decrement', as: 'cart_item_decrement'

  post '/shopping_lists/:id/toggle_check', to: 'shopping_lists#toggle_check', as: 'shopping_list_toggle_check'

  resources :completed_menus do
    member do
      # 献立のページで、提供する人数を変更するためのアクション
      post '/completed_menus/:menu_id/change_serving_size', to: 'completed_menus#change_serving_size', as: :change_serving_size

      # 作った献立を調理完了として設定するアクション
      get 'mark_as_completed', to: 'completed_menus#mark_as_completed', as: :mark_as
    end
  end

  devise_for :users
  devise_scope :user do
    get 'users/registration', to: 'custom_registrations#new', as: :new_user_custom_registration
    post 'users/registration', to: 'custom_registrations#create', as: :user_custom_registration
    get 'users/session', to: 'custom_sessions#new', as: :new_user_custom_session
    post 'users/session', to: 'custom_sessions#create', as: :user_custom_session
    get 'users/sessions', to: 'custom_sessions#destroy', as: :destroy_user_custom_session
    get 'registrations/edit', to: 'custom_registrations#edit', as: :edit_user_custom_registration
    patch 'registrations/update', to: 'custom_registrations#update', as: :update_user_custom_registration

    resources :users do
      resources :menus do
        post 'new', on: :collection, to: 'menus#new', as: :new_user_menu
        post 'edit', on: :collection, to: 'menus#edit', as: :edit_confirm
        post :change_serving_size
        resources :ingredients
      end
    end
  end
end
