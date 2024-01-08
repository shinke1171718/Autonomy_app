class CustomSessionsController < ApplicationController
  include FlashAndRedirect
  skip_before_action :authenticate_user!

  def new
  end

  def create
    if params[:email].blank? || params[:password].blank?
      set_flash_and_redirect(:error, "未入力があります。", root_path)
      return
    end

    #userのemailとパスワードを格納する
    user = User.find_by(email: params[:email])
    #userとパスワードが一致するか確認
    if user && user.valid_password?(params[:password])
      #セッションIDを払い出す
      session[:user_id] = user.id
      # current_userに値を設定する
      sign_in(user)
      #もし一致する場合にはroot_pathへ移動
      set_flash_and_redirect(:notice, "ログインしました。", root_path)
    else
      #ログインできませんでしたとアナウンス
      #合わない場合にはsessions#newへ戻る
      set_flash_and_redirect(:error, "※ユーザー名もしくはパスワードが間違っています。", root_path)
    end
  end

  def destroy
    #セッションIDを処分
    session[:user_id] = nil
    #ログでsessions_idがnilになったか確認するためにコード
    Rails.logger.debug "session[:user_id] = #{session[:user_id]}"
    #セッションの完全な処理
    reset_session
    #sessions#newへ戻る
    #一時的にsigninの画面にパスを出しています。
    set_flash_and_redirect(:notice, "※ログアウトしました。", new_user_custom_session_path)
  end
end