class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :authenticate_user!
  before_action :load_settings
  before_action :check_shopping_list_menu_items
  before_action :check_completed_menus_date

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
    if current_user
      cart = current_user.cart
      @has_menu_items = cart&.shopping_list&.shopping_list_menus&.exists? || false
    end
  end

  # 作れる献立がある場合にメニューバーへ「献立を選ぶ」「献立を作る」の選択肢を追加するために設定
  def check_completed_menus_date
    if current_user
      @completed_menus_date = CompletedMenu.where(user_id: current_user&.id, is_completed: false).exists?
    end
  end

  def handle_general_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to root_path
  end
end
