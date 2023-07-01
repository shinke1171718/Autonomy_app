class CustomSessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def new
  end

  def create
    #userのidとパスワードを格納する
    user = User.find_by(name: params[:name])
    #userとパスワードが一致するか確認
    if user && user.valid_password?(params[:password])
      #セッションIDを払い出す
      session[:user_id] = user.id
      #ログインしましたとアナウンス
      flash[:notice] = "ログインしました"
      #もし一致する場合にはroot_pathへ移動
      redirect_to new_user_custom_session_path
    else
      #ログインできませんでしたとアナウンス
      flash[:notice] = "ユーザー名かパスワードのどちらかが違います。"
      #合わない場合にはsessions#newへ戻る
      render 'new'
    end
  end

  def destroy
    binding.pry
    #セッションIDを処分
    session[:user_id] = nil
    #ログでsessions_idがnilになったか確認するためにコード
    Rails.logger.debug "session[:user_id] = #{session[:user_id]}"
    #セッションの完全な処理
    reset_session
    #sessions#newへ戻る
    flash[:notice] = "ログアウトしました。"
    #一時的にsigninの画面にパスを出しています。
    redirect_to new_user_custom_session_path
  end
end