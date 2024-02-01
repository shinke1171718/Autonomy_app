class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  # ホーム画面のアクション
  def index
    cart = current_user.cart
    @cart_items = cart.cart_items.includes(:menu).order(:added_at) if cart
  end

  # マイページ画面のアクション
  def my_page
  end

  # ユーザー情報画面のアクション
  def user_info
    @user = User.find(params[:id])
  end
end
