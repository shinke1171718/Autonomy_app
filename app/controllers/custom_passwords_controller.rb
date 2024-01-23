class CustomPasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  def request_reset
  end

  def send_reset_instructions
    # メールアドレスが空かどうかを確認
    if params[:user][:email].blank?
      flash[:error] = "未入力があります。"
      redirect_to request_reset_password_path
      return
    end

    # メールアドレスに該当するユーザーを検索
    user = User.find_by(email: params[:user][:email].downcase)

    # ユーザーが存在しない場合の処理
    if user.nil?
      flash[:error] = "該当するユーザーが存在しません。"
      redirect_to request_reset_password_path
      return
    end

    # ユーザーが存在する場合、パスワードリセット用のメールを送信
    user.send_reset_password_instructions
    flash[:notice] = "パスワードリセットに関するご案内メールを送信しました。"
    redirect_to request_reset_password_path
  end

  def verify_reset_token
    # パラメータからトークンを取得
    token = params[:reset_password_token]

    # トークンに対応するユーザーを検索
    user = User.with_reset_password_token(token)

    # ユーザーが存在し、トークンが有効であればパスワード変更フォームへリダイレクト
    if user && user.reset_password_period_valid?
      redirect_to edit_password_path
    else
      # トークンが無効な場合、エラーメッセージを表示
      flash[:error] = "パスワードリセットトークンが無効か、期限切れです。"
      redirect_to request_reset_password_path
    end
  end

  def edit_password
  end

end
