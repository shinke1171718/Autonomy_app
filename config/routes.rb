Rails.application.routes.draw do
  root to: 'users#index'

  get 'users/:id/my_page', to: 'users#my_page', as: :user_my_page

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
        member do
          get 'confirm', to: 'menus#confirm', as: :confirm
          delete :destroy_related_data, as: :destroy_related_data
          get 'reset_session', to: 'menus#reset_session', as: :reset_session
        end
        resources :ingredients
      end
    end
  end
end
