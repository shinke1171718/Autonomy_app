class CustomSessionsController < ApplicationController
  include FlashAndRedirect
  skip_before_action :authenticate_user!

  def new
  end

  def create
    # 未入力があるかチェック
    if params[:user][:email].blank? || params[:user][:password].blank?
      set_flash_and_redirect(:error, "未入力があります。", root_path)
      return
    end

    #userのemailとパスワードを格納する
    user = User.find_by(email: params[:user][:email])

    # userが存在しない、またはパスワードが一致しない場合
    if user.nil? || !user.valid_password?(params[:user][:password])
      set_flash_and_redirect(:error, "※メールアドレスもしくはパスワードが間違っています。", root_path)
      return
    end

    # ユーザーが未認証の場合
    if !user.confirmed?
      set_flash_and_redirect(:error, "メールアドレス認証を行ってください。", root_path)
    end

    # current_userに値を設定する
    sign_in(user)
    #もし一致する場合にはroot_pathへ移動
    set_flash_and_redirect(:notice, "ログインしました。", root_path)
  end

  def destroy
    #セッションの完全な処理
    reset_session
    #sessions#newへ戻る
    set_flash_and_redirect(:notice, "※ログアウトしました。", landing_pages_show_path)
  end

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲスト様"
      user.password = 'guest123'
      user.skip_confirmation!
    end
    sign_in user
    set_flash_and_redirect(:notice, "ゲストユーザーとしてログインしました。", root_path)
  end
end