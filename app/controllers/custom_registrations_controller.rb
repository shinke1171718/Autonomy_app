class CustomRegistrationsController < ApplicationController
  include Devise::Controllers::Helpers

  def new
    @user = User.new
  end

  def create
    #user情報を格納する
    @user = User.new(user_params)

    #入力したデータでエラーがないかチェック
    if User.find_by(name: @user.name)
      flash[:notice] = "※そのユーザー名は既に使用されています。"
      render 'new'
    elsif User.find_by(email: @user.email)
      flash[:notice] = "※そのメールアドレスは既に使用されています。"
      render 'new'
    elsif @user.password != @user.password_confirmation
      flash[:notice] = "※入力したパスワードが一致しません。"
      render 'new'
    end

    #問題なければログインする
    if @user.save
      #セッションIDを払い出す
      session[:user_id] = @user.id
      #ログインしましたとアナウンス
      flash[:notice] = "※ログインしました（一時的にリダイレクト先として設定。ホーム画面設定後に再設定してください。）"
      #もし一致する場合にはroot_pathへ移動（一時的にです。）
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
