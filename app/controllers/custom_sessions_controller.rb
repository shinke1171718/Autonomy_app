class CustomSessionsController < ApplicationController
  include FlashAndRedirect
  skip_before_action :authenticate_user!

  def new
  end

  def create
    # 未入力があるかチェック
    if params[:email].blank? || params[:password].blank?
      set_flash_and_redirect(:error, "未入力があります。", root_path)
      return
    end

    #userのemailとパスワードを格納する
    user = User.find_by(email: params[:email])

    # userが存在しない、またはパスワードが一致しない場合
    if user.nil? || !user.valid_password?(params[:password])
      set_flash_and_redirect(:error, "※メールアドレスもしくはパスワードが間違っています。", root_path)
      return
    end

    # ユーザーが未認証の場合
    if !user.confirmed?
      set_flash_and_redirect(:error, "メールアドレス認証を行ってください。", root_path)
    end

    #セッションIDを払い出す
    session[:user_id] = user.id
    # current_userに値を設定する
    sign_in(user)
    #もし一致する場合にはroot_pathへ移動
    set_flash_and_redirect(:notice, "ログインしました。", root_path)
  end

  def destroy
    #セッションの完全な処理
    reset_session
    #sessions#newへ戻る
    set_flash_and_redirect(:notice, "※ログアウトしました。", new_user_custom_session_path)
  end
end