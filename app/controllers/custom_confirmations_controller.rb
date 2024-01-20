class CustomConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:custom_confirm, :show_resend_confirmation_form]

  def show_resend_confirmation_form
    # user_idが送信された場合の処理
    if params[:user_id].present?
      user = User.find_by(id: params[:user_id])
      @user_email = user.email

    # user_idが送信されていない場合の処理
    else
      redirect_to root_path
    end


  end

  def custom_confirm
    # confirmation_tokenを使ってユーザーを検索
    user = User.find_by(confirmation_token: params[:confirmation_token])

    # 確認トークンの期限
    token_validity = @settings.dig('confirmation', 'token_validity_hours').hours

    # ユーザーが期限切れで削除されている、もしくは現在時刻が確認トークンの期限を過ぎている場合
    if user.nil? || user.confirmation_sent_at <= token_validity.ago
      flash[:error] = "無効な認証リンクです。"
      redirect_to root_path
      return
    end

    # ユーザーが既に認証済みの場合
    if user.confirmed?
      flash[:notice] = "すでに認証は完了しています。ログインしてください。"
      redirect_to root_path
      return
    else
      user.confirm
      # 任意の成功メッセージを設定
      flash[:notice] = "メールアドレスが認証されました。ログインしてください。"
      redirect_to root_path
    end
  end
end