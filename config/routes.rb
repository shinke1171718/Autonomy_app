Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'users/registration', to: 'custom_registrations#new', as: :new_user_custom_registration
    post 'users/registration', to: 'custom_registrations#create', as: :user_custom_registration
  end
end
