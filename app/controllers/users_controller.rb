class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  def index
    cart = current_user.cart
    @cart_items = cart.cart_items.includes(:menu) if cart
  end
end
