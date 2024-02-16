Rails.application.routes.draw do
  root to: 'users#index'
  get 'users/:id/my_page', to: 'users#my_page', as: :user_my_page
  get 'users/:id/user_info', to: 'users#user_info', as: :user_info

  post '/users/:user_id/menus/confirm', to: 'menus#confirm', as: :confirm_user_menu
  post 'users/:user_id/menus/units', to: 'menus#units'

  # ユーザーが作成した献立用のルーティング
  get 'users/:user_id/custom_menus', to: 'menus#custom_menus', as: :user_custom_menus

  # 標準献立用のルーティング
  get 'sample_menus', to: 'menus#sample_menus', as: :sample_menus

  # CartItem#createへのルーティング
  resources :cart_items
  resources :shopping_lists
  post 'shopping_lists/check_items', to: 'shopping_lists#check_items'

  # カートアイテムの数量を増やす
  post '/cart_items/:id/increment', to: 'cart_items#increment', as: 'cart_item_increment'
  # カートアイテムの数量を減らす
  post '/cart_items/:id/decrement', to: 'cart_items#decrement', as: 'cart_item_decrement'
  post '/shopping_lists/:id/toggle_check', to: 'shopping_lists#toggle_check', as: 'shopping_list_toggle_check'

  resources :cooking_flows do
    member do
      patch :complete
    end
  end

  devise_for :users
  devise_scope :user do
    get 'users/confirmation/custom_confirm', to: 'custom_confirmations#custom_confirm', as: :custom_user_confirmation
    get 'users/confirmation/resend', to: 'custom_confirmations#show_resend_confirmation_form', as: :show_resend_confirmation_form

    get 'users/registration', to: 'custom_registrations#new', as: :new_user_custom_registration
    post 'users/registration', to: 'custom_registrations#create', as: :user_custom_registration
    get 'users/session', to: 'custom_sessions#new', as: :new_user_custom_session
    post 'users/session', to: 'custom_sessions#create', as: :user_custom_session
    get 'users/sessions', to: 'custom_sessions#destroy', as: :destroy_user_custom_session

    # パスワードを忘れた場合の処理に関するルーチング
    get 'password/request_reset', to: 'custom_passwords#request_reset', as: :request_reset_password
    post 'password/send_reset_instructions', to: 'custom_passwords#send_reset_instructions', as: :send_reset_instructions
    get 'password/verify_reset_token', to: 'custom_passwords#verify_reset_token', as: :verify_reset_token
    get 'password/edit', to: 'custom_passwords#edit_password', as: :edit_password
    patch 'password/update', to: 'custom_passwords#update_password', as: :update_password

    # ユーザー名更新用のルーティング
    get 'registrations/edit_user_name', to: 'custom_registrations#edit_user_name', as: :edit_user_name_custom_registration
    patch 'registrations/user_name_update', to: 'custom_registrations#user_name_update', as: :user_name_update_custom_registration
    # メールアドレス更新用のルーティング
    get 'registrations/edit_email', to: 'custom_registrations#edit_email', as: :edit_email_custom_registration
    patch 'registrations/email_update', to: 'custom_registrations#email_update', as: :email_update_custom_registration
    # パスワード更新用のルーティング
    get 'registrations/edit_password', to: 'custom_registrations#edit_password', as: :edit_password_user_custom_registration
    patch 'registrations/update_password_info', to: 'custom_registrations#password_info_update', as: :password_info_update_custom_registration

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
