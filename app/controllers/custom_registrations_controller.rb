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

  def edit
  end

  def edit_password
  end

  def update
    # ユーザー情報の更新
    if user_params.present? && current_user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to edit_user_custom_registration_path
      return
    elsif user_params.present?
      set_error_flash(current_user)
      redirect_to edit_user_custom_registration_path
      return
    end

    # パスワード更新
    if current_user.update(password_params)
      flash[:notice] = "パスワードを更新しました。再度ログインをお願いします。"
      redirect_to root_path
    else
      set_error_flash(current_user)
      redirect_to edit_password_user_custom_registration_path
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end

  def new_registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def set_error_flash(user)
    flash[:error] = user.errors.full_messages.first.sub(/^.*\s/, '')
  end
end
