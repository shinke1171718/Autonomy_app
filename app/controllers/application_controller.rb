class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :load_settings
  before_action :check_shopping_list_menu_items

  private

  def authenticate_user!
    unless current_user
      redirect_to new_user_custom_session_path
    end
  end

  # 各アクション内で必要な設定値を @settings 変数に格納
  def load_settings
    @settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
  end

  # 現在のユーザーのカートに紐づくショッピングリストに関連するメニュー項目が存在するかをチェック
  def check_shopping_list_menu_items
    cart = current_user.cart
    if cart && cart.shopping_list
      @has_menu_items = cart.shopping_list.shopping_list_menus.exists?
    else
      @has_menu_items = false
    end
  end

  def handle_general_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to root_path
  end
end
