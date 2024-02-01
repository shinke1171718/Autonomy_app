class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :authenticate_user!
  before_action :load_settings

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

  def handle_general_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to root_path
  end
end
