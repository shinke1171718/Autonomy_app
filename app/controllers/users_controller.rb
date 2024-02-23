class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  # ホーム画面のアクション
  def index
    @cart_items = cart_items.includes(:menu).order(:added_at) if current_user_cart
  end

  # マイページ画面のアクション
  def my_page
  end

  # ユーザー情報画面のアクション
  def user_info
    @user = User.find(params[:id])
  end
end
