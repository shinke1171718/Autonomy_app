class CustomRegistrationsController < ApplicationController
  include FlashAndRedirect
  include SetValidationErrorHelper
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
      redirect_to show_resend_confirmation_form_path(user_id: user.id)
    else
      set_flash_and_redirect(:error, set_validation_error(user), new_user_custom_registration_path)
    end
  end


  # ユーザー名の変更画面
  def edit_user_name
  end


  # ユーザー名の変更アクション
  def user_name_update
    if params[:user][:name].blank?
      set_flash_and_redirect(:error, "未入力があります。", edit_user_name_custom_registration_path)
      return
    end

    if current_user.update(registration_params)
      set_flash_and_redirect(:notice, "ユーザー名を更新しました。", edit_user_name_custom_registration_path)
    else
      set_flash_and_redirect(:error, set_validation_error(current_user), edit_user_name_custom_registration_path)
    end
  end


  # メールアドレスの変更画面
  def edit_email
  end


  # メールアドレスの変更アクション
  def email_update
    if params[:user][:email].blank?
      set_flash_and_redirect(:error, "未入力があります。", edit_email_custom_registration_path)
      return
    end

    # 入力されたメールアドレスが現在のメールアドレスと同じかどうかをチェック
    if params[:user][:email] == current_user.email
      set_flash_and_redirect(:error, "登録済みのアドレスです。", edit_email_custom_registration_path)
      return
    end

    # 新しいメールアドレスに確認メールを送信
    if current_user.update(registration_params)
      set_flash_and_redirect(:notice, "メールアドレス更新の確認メールを送信しました。", edit_email_custom_registration_path)
    else
      set_flash_and_redirect(:error, set_validation_error(current_user), edit_email_custom_registration_path)
    end
  end


  # パスワードの変更画面
  def edit_password
  end


  # パスワードの変更アクション
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :user_info_change, :email_change, :password_change)
  end
end
