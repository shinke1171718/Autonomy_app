class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :load_settings
  before_action :set_cart_items

  private

  #標準設定だとdeviseのデフォルトのview画面に飛ぶためリダイレクト先を再設定します。
  def authenticate_user!
    unless current_user
      redirect_to new_user_custom_session_path
    end
  end

  # 各アクション内で必要な設定値を @settings 変数に格納
  def load_settings
    @settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
  end

  def set_cart_items
    cart = current_user.cart
    @cart_items = cart.cart_items.includes(:menu) if cart
  end
end
