class CustomRegistrationsController < ApplicationController
  include FlashAndRedirect
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    #user情報を格納する
    user = User.new(registration_params)

    if user_info_missing? && password_info_missing?
      set_flash_and_redirect(:error, "未入力があります。", new_user_custom_registration_path)
      return
    end

    if user.save
      session[:user_id] = user.id
      sign_in(user)
      set_flash_and_redirect(:notice, "ログインしました。", root_path)
    else
      set_flash_and_redirect(:error, set_validation_error(user), new_user_custom_registration_path)
    end
  end

  def edit_user
  end

  def edit_password
  end

  def email_update
    if params[:user][:email].blank?
      set_flash_and_redirect(:error, "未入力があります。", edit_email_custom_registration_path)
      return
    end

    # ユーザー情報の更新
    if current_user.update(registration_params)
      set_flash_and_redirect(:notice, "ユーザー情報を更新しました。", edit_email_custom_registration_path)
    else
      set_flash_and_redirect(:error, set_validation_error(current_user), edit_email_custom_registration_path)
      return
    end
  end

  def password_info_update
    if password_info_missing?
      set_flash_and_redirect(:error, "未入力があります。", edit_password_user_custom_registration_path)
      return
    end

    if !current_user.valid_password?(params[:user][:current_password])
      set_flash_and_redirect(:error, "現在のパスワードが正しくありません。", edit_password_user_custom_registration_path)
      return
    end

    if current_user.update(registration_params)
      set_flash_and_redirect(:notice, "パスワードを更新しました。再度ログインをお願いします。", root_path)
    else
      set_flash_and_redirect(:error, set_validation_error(current_user), edit_password_user_custom_registration_path)
      return
    end
  end

  private

  # ユーザー情報関連のパラメータが提供されているか確認
  # フィールドの未入力チェックはコントローラーレベルで行う。
  # モデルのバリデーションでは、フィールドが空の場合のチェックができないため、
  # 未入力の状態で適切なエラーメッセージを提供するためにはコントローラーでのチェックが必要。
  def user_info_missing?
    params[:user][:name].blank? || params[:user][:email].blank?
  end

  #「if user_info_missing?」での説明と同様
  def password_info_missing?
    params[:user][:current_password].blank? ||
    params[:user][:password].blank? ||
    params[:user][:password_confirmation].blank?
  end

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :email_change, :password_change)
  end

  def set_validation_error(user)
    user.errors.full_messages.first.sub(/^.*\s/, '')
  end
end
