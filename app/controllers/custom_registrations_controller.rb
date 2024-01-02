class CustomRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

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
      return
    elsif User.find_by(email: user.email)
      flash[:notice] = "※そのメールアドレスは既に使用されています。"
      render 'new'
      return
    elsif user.password != user.password_confirmation
      flash[:notice] = "※入力したパスワードが一致しません。"
      render 'new'
      return
    end

    #問題なければログインする
    if flash[:sign_up_notice].present?
      render 'new'
    elsif user.save
      session[:user_id] = user.id
      sign_in(user)
      flash[:notice] = "ログインしました。"
      redirect_to root_path
    end
  end

  def edit
  end

  def edit_password
  end

  def update
    # ユーザー情報の更新
    if user_params.present?
      update_user_info
      return
    end

    # パスワード更新
    # 未入力があるかチェック
    if !password_params.keys.all? { |key| password_params[key].present? }
      flash[:error] = "未入力がありました。"
      redirect_to edit_password_user_custom_registration_path
      return
    end

    # 現在のパスワードがあっているかチェック
    if !current_user.valid_password?(password_params[:current_password])
      flash[:error] = "入力された「現在のパスワード」が正しくありません。"
      redirect_to edit_password_user_custom_registration_path
      return
    end

    # パスワードをアップデート
    if current_user.update(password_params)
      flash[:notice] = "パスワードを更新しました。再度ログインをお願いします。"
      redirect_to edit_password_user_custom_registration_path
      return

    # パスワードの「形式誤り」と「新しいパスワードと再入力が一致しない」場合の処理
    else
      check_password_errors
      redirect_to edit_password_user_custom_registration_path
    end

  end

  private

  def set_flash_error_messages
    if current_user.errors.details[:name].any? { |error| error[:error] == :blank } ||
       current_user.errors.details[:email].any? { |error| error[:error] == :blank }
      flash[:error] = "未入力の項目がありました。"
    else
      flash[:error] = "ユーザー情報の更新に失敗しました。"
    end
  end

  # ユーザー情報の更新を行うメソッド
  def update_user_info
    if current_user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to edit_user_custom_registration_path
    else
      set_flash_error_messages
      redirect_to edit_user_custom_registration_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  # パスワードの「形式誤り」か「新しいパスワードと再入力が一致しない」場合にエラーメッセージを設定する
  def check_password_errors
    if current_user.errors.added?(:password_confirmation, "doesn't match Password")
      flash[:error] = "新しいパスワード(確認)は新しいパスワードと一致しません。"
    elsif current_user.errors.added?(:password, "is invalid")
      flash[:error] = "パスワードには英字と数字を両方含む必要があります。"
    end
  end

end
