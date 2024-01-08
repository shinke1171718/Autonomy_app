class CustomRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    #user情報を格納する
    user = User.new(new_registration_params)

    if user.save
      session[:user_id] = user.id
      sign_in(user)
      flash[:notice] = "ログインしました。"
      redirect_to root_path
    else
      set_error_flash(user)
      redirect_to new_user_custom_registration_path
    end
  end

  def edit_user
  end

  def edit_password
  end

  def user_info_update
    # フィールドの未入力チェックはコントローラーレベルで行う。
    # モデルのバリデーションでは、フィールドが空の場合のチェックが難しいため、
    # 未入力の状態で適切なエラーメッセージを提供するためにはコントローラーでのチェックが必要。
    if user_info_missing?
      flash[:error] = "未入力があります。"
      redirect_to edit_user_custom_registration_path
      return
    end

    # ユーザー情報の更新
    if current_user.update(registration_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to edit_user_custom_registration_path
    else
      set_error_flash(current_user)
      redirect_to edit_user_custom_registration_path
      return
    end
  end

  def password_info_update
    # ser_info_updateアクションの「if user_info_missing?」での説明と同様
    if password_info_missing?
      flash[:error] = "未入力があります。"
      redirect_to edit_password_user_custom_registration_path
      return
    end

    if !current_user.valid_password?(params[:user][:current_password])
      errors.add(:current_password, '現在のパスワードが正しくありません')
      redirect_to edit_password_user_custom_registration_path
      return
    end

    if current_user.update(registration_params)
      flash[:notice] = "パスワードを更新しました。再度ログインをお願いします。"
      redirect_to root_path
    else
      set_error_flash(current_user)
      redirect_to edit_password_user_custom_registration_path
      return
    end
  end

  private

  # ユーザー情報関連のパラメータが提供されているか確認
  def user_info_missing?
    params[:user][:name].blank? || params[:user][:email].blank?
  end

  # パスワード関連のパラメータが提供されているか確認
  def password_info_missing?
    params[:user][:current_password].blank? ||
    params[:user][:password].blank? ||
    params[:user][:password_confirmation].blank?
  end

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def set_error_flash(user)
    flash[:error] = user.errors.full_messages.first.sub(/^.*\s/, '')
  end
end
