class CustomRegistrationsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    #user情報を格納する
    user = User.new(user_params)

    #入力したデータでエラーがないかチェック
    if User.find_by(name: user.name)
      flash[:notice] = "※そのユーザー名は既に使用されています。"
      render 'new'
    elsif User.find_by(email: user.email)
      flash[:notice] = "※そのメールアドレスは既に使用されています。"
      render 'new'
    elsif user.password != user.password_confirmation
      flash[:notice] = "※入力したパスワードが一致しません。"
      render 'new'
    end

    #問題なければログインする
    if user.save
      #セッションIDを払い出す
      session[:user_id] = user.id
      # current_userに値を設定する
      sign_in(user)
      #ログインしましたとアナウンス
      flash[:notice] = "※ログインしました。"
      #もし一致する場合にはroot_pathへ移動（一時的にです。）
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
  end

  def update
    #ユーザーのデータを格納する
    @user = current_user

    if edit_user_params[:password].present? && edit_user_params[:password_confirmation].present?
      # パスワードがある場合の処理
      if !@user.authenticate(edit_user_params[:current_password])
        flash[:notice] = "現在のパスワードが正しくありません。"
        render :edit
        return
      end

      @user.update(edit_user_params)
      flash[:notice] = "ユーザー情報とパスワードを更新しました。"
      render :edit
    else
      # パスワードがない場合の処理
      @user.update(user_params_without_password)
      flash[:notice] = "ユーザー情報を更新しました。（パスワード未更新：パスワードを設定された場合には入力漏れがないか確認してください。）"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def edit_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def user_params_without_password
    params.require(:user).permit(:name, :email)
  end

end
