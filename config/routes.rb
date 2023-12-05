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
  resources :cart_items, only: [:create, :destroy]

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
        resources :ingredients
      end
    end
  end
end
