class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :authenticate_user!
  before_action :load_settings
  helper_method :current_user_cart, :cart_items, :shopping_list_items

  private

  def authenticate_user!
    unless current_user
      redirect_to landing_pages_show_path
    end
  end

  # 各アクション内で必要な設定値を @settings 変数に格納
  def load_settings
    @settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
  end

  def handle_general_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to root_path
  end

  def current_user_cart
    current_user&.cart
  end

  def cart_items
    current_user_cart&.cart_items
  end

  def shopping_list_items
    current_user&.cart&.shopping_list&.shopping_list_items
  end
end