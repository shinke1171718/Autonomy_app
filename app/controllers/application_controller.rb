class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  private

  #標準設定だとdeviseのデフォルトのview画面に飛ぶためリダイレクト先を再設定します。
  def authenticate_user!
    unless current_user
      redirect_to new_user_custom_session_path
    end
  end
end
