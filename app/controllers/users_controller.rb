class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  def index
    cart = current_user.cart
    @cart_items = cart.cart_items.includes(:menu) if cart
  end

  def my_page
  end

  def user_info
    @user = User.find(params[:id])
  end
end
